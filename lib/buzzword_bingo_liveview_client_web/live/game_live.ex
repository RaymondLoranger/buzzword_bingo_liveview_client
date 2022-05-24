defmodule Buzzword.Bingo.LiveView.ClientWeb.GameLive do
  use Buzzword.Bingo.LiveView.ClientWeb, :live_view
  use Buzzword.Bingo.LiveView.ClientWeb, :aliases

  require Logger

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        player: nil,
        topic: nil,
        size: nil,
        players: [],
        squares: []
      )

    {:ok, socket, temporary_assigns: [squares: []]}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_event("validate", %{"user" => user}, socket) do
    changeset = User.changeset(user) |> struct(action: :insert)
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => user}, socket) do
    case User.apply_insert(user) do
      {:ok, user} ->
        player = Player.new(user.name, user.color)
        socket = assign(socket, player: player)
        {:noreply, push_patch(socket, to: socket.assigns.return_to)}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  # def handle_info({:square_click, square}, socket) do
  #   Endpoint.broadcast(socket.assigns.topic, "square-click", square)
  #   {:noreply, put_flash(socket, :info, "Square #{square.phrase} clicked")}
  # end

  def handle_info(%Broadcast{event: "square-click", payload: square}, socket) do
    IO.inspect(square, label: "-- Square broadcasted!!! --")
    {:noreply, update(socket, :squares, &[square | &1])}
  end

  def handle_info(%Broadcast{event: "presence_diff"} = msg, socket) do
    %Broadcast{payload: %{joins: joins, leaves: leaves}, topic: _topic} = msg
    IO.inspect(joins, label: "-- presence joins --")
    IO.inspect(leaves, label: "-- presence leaves --")
    players = Presence.list(socket.assigns.topic)
    IO.inspect(players, label: "-- presence list --")

    # players =
    #   players
    #   |> Enum.map(fn {name, %{metas: [%{color: color} | _]}} ->
    #     %{id: name <> color, name: name, color: color, points: 0, marked: 0}
    #   end)

    # players =
    #   for {name, %{metas: metas}} <- players do
    #     for %{color: _, online_at: _, phx_ref: _} = meta <- metas do
    #       Map.merge(meta, %{name: name, points: 0, marked: 0})
    #     end
    #   end
    #   |> List.flatten()

    players =
      players
      |> Enum.map(fn {name, %{metas: [meta | _]}} ->
        Map.merge(meta, %{name: name, points: 0, marked: 0})
      end)

    IO.inspect(players, label: "-- players list --")
    {:noreply, assign(socket, players: players)}
  end

  def handle_info(msg, socket) when is_binary(msg) do
    {:noreply, put_flash(socket, :info, msg)}
  end

  def handle_info(msg, socket) do
    Logger.error("""
    *** UNKNOWN MESSAGE RECEIVED ***
    #{inspect(msg)}
    """)

    {:noreply, socket}
  end

  ## Private functions

  # /login or /login/:to
  defp apply_action(socket, :login, params) do
    return_to = params["to"] || Routes.game_path(socket, :new)

    assign(socket,
      page_title: "User login",
      changeset: User.changeset(),
      return_to: return_to
    )
  end

  # /games/new
  defp apply_action(socket, :new, _params) when is_nil(socket.assigns.player) do
    return_to = Routes.game_path(socket, :new)
    push_patch(socket, to: Routes.game_path(socket, :login, return_to))
  end

  defp apply_action(socket, :new, _params) do
    assign(socket, :page_title, "Game size")
  end

  # /games/:id
  defp apply_action(socket, :show, %{"id" => game_name})
       when is_nil(socket.assigns.player) do
    return_to = Routes.game_path(socket, :show, game_name)
    push_patch(socket, to: Routes.game_path(socket, :login, return_to))
  end

  defp apply_action(socket, :show, %{"id" => game_name}) do
    topic = "game:" <> game_name
    Endpoint.subscribe(topic)
    player = socket.assigns.player

    meta = %{
      color: player.color,
      online_at: DateTime.utc_now() |> DateTime.to_string()
    }

    Presence.track(self(), topic, player.name, meta)
    squares = Engine.game_summary(game_name).squares
    size = length(squares)
    squares = List.flatten(squares)

    assign(socket,
      page_title: "Game #{game_name}",
      game_name: game_name,
      player: player,
      topic: topic,
      size: size,
      squares: squares
    )
  end
end
