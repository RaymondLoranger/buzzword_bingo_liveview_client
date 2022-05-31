defmodule Buzzword.Bingo.LiveView.ClientWeb.MessageFormComponent do
  use Buzzword.Bingo.LiveView.ClientWeb, :live_component
  use Buzzword.Bingo.LiveView.ClientWeb, :aliases

  require Logger

  def mount(socket) do
    socket = assign(socket, text: "")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div id="message-form" class={@class}>
      <.form let={f} for={:message} phx-submit="send" phx-target={@myself}
          phx-change="form_change">
        <span>
          <%= text_input f, :text, value: @text,
                placeholder: "Enter your message..." %>
        </span>
        <span>
          <%= submit "Send", phx_disable_with: "Sending..." %>
        </span>
      </.form>
    </div>
    """
  end

  def handle_event("form_change", %{"message" => message}, socket) do
    {:noreply, assign(socket, text: message["text"])}
  end

  def handle_event("send", %{"message" => message}, socket) do
    player = socket.assigns.player
    message = %{id: UUID.generate(), text: message["text"], sender: player}
    Endpoint.broadcast(socket.assigns.topic, "new_message", message)
    {:noreply, assign(socket, text: "")}
  end
end
