defmodule Buzzword.Bingo.LiveView.ClientWeb.GameComponent do
  use Buzzword.Bingo.LiveView.ClientWeb, :live_component
  use Buzzword.Bingo.LiveView.ClientWeb, :aliases

  def mount(socket) do
    {:ok, socket, temporary_assigns: [squares: []]}
  end

  def update(assigns, socket) do
    squares = Engine.game_summary(assigns.game_name).squares
    size = length(squares)
    squares = List.flatten(squares)
    {:ok, socket |> assign(assigns) |> assign(size: size, squares: squares)}
  end

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
    squares = Engine.mark_square(game_name, phrase, player).squares
    square = List.flatten(squares) |> Enum.find(&(&1.phrase == phrase))
    Endpoint.broadcast(socket.assigns.topic, "square-click", square)
    # send(self(), {:square_click, square})
    {:noreply, socket}
  end
end
