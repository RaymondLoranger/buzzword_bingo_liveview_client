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

  def handle_event("play", %{"user" => user}, socket) do
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

  def handle_info(%Broadcast{event: "winner_alert", payload: winner}, socket) do
    {:noreply, assign(socket, winner: winner)}
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

  def handle_info({:error, msg}, socket) when is_binary(msg) or is_list(msg) do
    {:noreply, put_flash(socket, :error, raw(msg))}
  end

  def handle_info(msg, socket) when is_binary(msg) or is_list(msg) do
    {:noreply, put_flash(socket, :info, raw(msg))}
  end

  def handle_info(msg, socket) do
    Logger.warn("""
    ::: Unknown message :::
    #{inspect(msg)}
    """)

    {:noreply, socket}
  end

  def terminate(reason, socket) do
    player = socket.assigns[:player]
    game_name = socket.assigns[:game_name]
    players = socket.assigns[:players]

    if player do
      Logger.warn("Player '#{player.name}' quitting game '#{game_name}'.")
    else
      Logger.warn("Unknown player quitting game '#{game_name}'.")
    end

    Logger.warn("Reason: #{inspect(reason)}")

    if players && map_size(players) == 1 do
      Logger.warn("Ending game: #{game_name}")
      Engine.end_game(game_name)
    end
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
    assign(socket, page_title: "Game size")
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
    url = Routes.game_url(socket, :show, game_name) |> Clipboard.copy()
    player = socket.assigns.player
    topic = "game:" <> game_name

    {game_size, squares} =
      case Engine.game_summary(game_name) do
        %Summary{squares: squares} ->
          Endpoint.subscribe(topic)
          meta = %{color: player.color, score: 0, marked: 0}
          Presence.track(self(), topic, player.name, meta)
          {length(squares), List.flatten(squares)}

        {:error, _} ->
          send(self(), {:error, error_msg(game_name)})
          {0, []}
      end

    assign(socket,
      page_title: "Game #{game_name}",
      game_name: game_name,
      topic: topic,
      game_size: game_size,
      squares: squares,
      url: url,
      winner: nil
    )
  end

  # Private functions

  defp error_msg(game_name) do
    """
    Game
    <span class="font-bold">
      #{game_name}
    </span>
    not found!
    """
  end
end
