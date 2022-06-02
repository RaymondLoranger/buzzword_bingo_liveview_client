defmodule Buzzword.Bingo.LiveView.ClientWeb.GameComponent do
  use Buzzword.Bingo.LiveView.ClientWeb, :live_component
  use Buzzword.Bingo.LiveView.ClientWeb, :aliases

  def render(assigns) do
    ~H"""
    <div id="game">
      <.game_url url={@url} target={@myself}/>
      <div class="flex flex-col md:flex-row justify-center items-stretch gap-2">
        <.squares let={square} squares={@squares} game_size={@game_size}>
          <.square square={square} target={@myself}/>
        </.squares>
        <.game_over? winner={@winner}/>
        <div class="flex flex-col justify-between gap-3">
          <.players players={@players}/>
          <.messages messages={@messages} presences={map_size(@players)}/>
          <.live_component module={MessageFormComponent}
              id="message-form" topic={@topic} messages={@messages}
              player={@player}/>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("url_click", _payload, socket) do
    Clipboard.copy(socket.assigns.url)
    {:noreply, push_event(socket, "select-text", %{id: "game-url"})}
  end

  def handle_event("square_click", %{"id" => phrase}, socket) do
    %{game_name: game_name, topic: topic, player: player} = socket.assigns
    summary = Engine.mark_square(game_name, phrase, player)
    %Summary{squares: squares, scores: scores, winner: winner} = summary
    if winner, do: Endpoint.broadcast(topic, "winner_alert", winner)
    score = %{player.name => scores[player.name]}
    Endpoint.broadcast(topic, "score_fix", score)
    square = List.flatten(squares) |> Enum.find(&(&1.phrase == phrase))
    Endpoint.broadcast(topic, "square_fix", square)
    {:noreply, socket}
  end
end
