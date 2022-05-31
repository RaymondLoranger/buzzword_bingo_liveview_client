defmodule Buzzword.Bingo.LiveView.ClientWeb.GameComponent do
  use Buzzword.Bingo.LiveView.ClientWeb, :live_component
  use Buzzword.Bingo.LiveView.ClientWeb, :aliases

  def render(assigns) do
    assigns =
      assign(assigns,
        messages: [
          %{
            id: "1",
            sender: "Moi",
            body:
              "Bonjour, comment allez-vous ? Voulez-vous coucher avec moi ce soir ?"
          },
          %{
            id: "2",
            sender: "Me",
            body:
              "Howdy, how do you do? Well, let me think about such an unexpected offer!!"
          }
        ]
      )

    ~H"""
    <div id="game">
      <h1 class="text-center mb-2">Play Game <%= @game_name %></h1>
      <div class="flex justify-center items-stretch space-x-6">
        <.squares let={square} squares={@squares} game_size={@game_size}>
          <.square square={square} target={@myself} />
        </.squares>
        <div class="flex flex-col justify-between space-y-2">
          <.players players={@players}/>
          <.messages class="flex-grow" messages={@messages}/>
          <.live_component class="self-stretch" module={MessageFormComponent}
              id="message-form"/>
        </div>
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
