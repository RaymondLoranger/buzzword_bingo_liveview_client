defmodule Buzzword.Bingo.LiveView.ClientWeb.GameComponent do
  use Buzzword.Bingo.LiveView.ClientWeb, :live_component
  use Buzzword.Bingo.LiveView.ClientWeb, :aliases

  def render(assigns) do
    ~H"""
    <div id="game">
      <h1 class="text-center bg-indigo-200">Play Game <%= @game_name %></h1>
      <div class="flex">
        <.squares let={square} squares={@squares} game_size={@game_size}>
          <.square square={square} target={@myself} />
        </.squares>
        <.players players={@players} />
      </div>
    </div>
    """
  end

  def handle_event("square_click", %{"id" => phrase}, socket) do
    game_name = socket.assigns.game_name
    player = socket.assigns.player
    summary = Engine.mark_square(game_name, phrase, player)
    %Summary{squares: squares, scores: scores} = summary
    score = %{player.name => scores[player.name]}
    Endpoint.broadcast(socket.assigns.topic, "score_fix", score)
    square = List.flatten(squares) |> Enum.find(&(&1.phrase == phrase))
    Endpoint.broadcast(socket.assigns.topic, "square_fix", square)
    {:noreply, socket}
  end
end
