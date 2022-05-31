defmodule Buzzword.Bingo.LiveView.ClientWeb.GameLive do
  use Buzzword.Bingo.LiveView.ClientWeb, :live_view
  use Buzzword.Bingo.LiveView.ClientWeb, :aliases

  require Logger

  def mount(_params, _session, socket) do
    {:ok, assign(socket, player: nil, players: %{}),
     temporary_assigns: [squares: [], messages: []]}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_event("validate", %{"user" => user}, socket) do
    players = presence_players(socket.assigns.topic)
    changeset = User.changeset(user, players) |> struct(action: :insert)
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => user}, socket) do
    players = presence_players(socket.assigns.topic)

    case User.apply_insert(user, players) do
      {:ok, user} ->
        player = Player.new(user.name, user.color)
        socket = assign(socket, player: player)
        {:noreply, push_patch(socket, to: socket.assigns.return_to)}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_info(%Broadcast{event: "square_fix", payload: square}, socket) do
    {:noreply, update(socket, :squares, &[square | &1])}
  end

  def handle_info(%Broadcast{event: "score_fix", payload: score}, socket) do
    players = Map.merge(socket.assigns.players, score)
    {:noreply, assign(socket, players: players)}
  end

  def handle_info(%Broadcast{event: "new_message", payload: message}, socket) do
    {:noreply, update(socket, :messages, &[message | &1])}
  end

  def handle_info(%Broadcast{event: "presence_diff"}, socket) do
    %Summary{scores: scores} = Engine.game_summary(socket.assigns.game_name)
    players = presence_players(socket.assigns.topic)

    players =
      for {name, meta} <- players, into: %{} do
        {name, Map.merge(meta, scores[name] || %{})}
      end

    {:noreply, assign(socket, players: players)}
  end

  def handle_info(msg, socket) when is_binary(msg) do
    {:noreply, put_flash(socket, :info, msg)}
  end

  def handle_info(msg, socket) do
    Logger.error("""
    ::: Unknown message :::
    #{inspect(msg)}
    """)

    {:noreply, socket}
  end

  ## Private functions

  defp presence_players(topic) do
    for {name, %{metas: [meta | _]}} <- Presence.list(topic), into: %{} do
      {name, meta}
    end
  end

  # /login or /login/:to or /login/:to?game_name=...
  defp apply_action(socket, :login, params) do
    topic = "game:#{params["game_name"]}"
    return_to = params["to"] || Routes.game_path(socket, :new)

    assign(socket,
      page_title: "User login",
      changeset: User.changeset(),
      topic: topic,
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

    push_patch(socket,
      to: Routes.game_path(socket, :login, return_to, game_name: game_name)
    )
  end

  defp apply_action(socket, :show, %{"id" => game_name}) do
    player = socket.assigns.player
    topic = "game:" <> game_name
    Endpoint.subscribe(topic)
    meta = %{color: player.color, score: 0, marked: 0}
    Presence.track(self(), topic, player.name, meta)
    %Summary{squares: squares} = Engine.game_summary(game_name)
    game_size = length(squares)
    squares = List.flatten(squares)

    assign(socket,
      page_title: "Game #{game_name}",
      game_name: game_name,
      topic: topic,
      game_size: game_size,
      squares: squares
    )
  end
end
