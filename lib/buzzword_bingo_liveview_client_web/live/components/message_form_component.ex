defmodule Buzzword.Bingo.LiveView.ClientWeb.MessageFormComponent do
  use Buzzword.Bingo.LiveView.ClientWeb, :live_component
  use Buzzword.Bingo.LiveView.ClientWeb, :aliases

  def mount(socket) do
    {:ok, assign(socket, text: "")}
  end

  def render(assigns) do
    ~H"""
    <div id="message-form">
      <form phx-submit="send" phx-target={@myself} phx-change="text_change">
        <span class="input-duo">
          <input type="text" name="text" value={@text}
              placeholder="Enter your message...">
          <button type="submit" disabled={@text == ""}>
            <Solid.chat_alt_2 class="h-full aspect-square invert"/>
          </button>
        </span>
      </form>
    </div>
    """
  end

  def handle_event("text_change", %{"text" => text}, socket) do
    {:noreply, assign(socket, text: text)}
  end

  def handle_event("send", %{"text" => text}, socket) do
    player = socket.assigns.player
    message = %{id: UUID.generate(), text: text, sender: player}
    Endpoint.broadcast(socket.assigns.topic, "new_message", message)
    {:noreply, assign(socket, text: "")}
  end
end
