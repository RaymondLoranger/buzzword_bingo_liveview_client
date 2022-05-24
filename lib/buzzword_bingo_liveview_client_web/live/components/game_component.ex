defmodule Buzzword.Bingo.LiveView.ClientWeb.GameComponent do
  use Buzzword.Bingo.LiveView.ClientWeb, :live_component
  use Buzzword.Bingo.LiveView.ClientWeb, :aliases

  def render(assigns) do
    ~H"""
    <div id="game">
      <h1 class="text-center bg-indigo-200">Play Game <%= @game_name %></h1>
      <div class="flex">
        <.squares let={square} squares={@squares} size={@size}>
          <.square square={square} target={@myself} />
        </.squares>
        <.players players={@players} />
      </div>
    </div>
    """
  end

  def handle_event("square-click", %{"id" => phrase}, socket) do
    game_name = socket.assigns.game_name
    player = socket.assigns.player
    summary = Engine.mark_square(game_name, phrase, player)
    %Summary{squares: squares, scores: scores, winner: winner} = summary
    IO.inspect(scores, label: "==> Scores after #{phrase} marked")
    IO.inspect(winner, label: "==> Winner after #{phrase} marked")
    scorer = Map.put(scores[player.name], :name, player.name)
    # Broadcast scorer here. Maybe call event "scorer-cast"... "square-cast".
    # Or just event "scorer" and "square".
    # Or event "scorer-update" and "square-update".
    # Or event "scorer-updated" and "square-updated" like :post_updated.
    IO.inspect(scorer, label: "==> Scorer after #{phrase} marked")
    square = List.flatten(squares) |> Enum.find(&(&1.phrase == phrase))
    Endpoint.broadcast(socket.assigns.topic, "square-click", square)
    # send(self(), {:square_click, square})
    {:noreply, socket}
  end
end
