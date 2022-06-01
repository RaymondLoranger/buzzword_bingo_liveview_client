defmodule Buzzword.Bingo.LiveView.ClientWeb.MessageFormComponent do
  use Buzzword.Bingo.LiveView.ClientWeb, :live_component
  use Buzzword.Bingo.LiveView.ClientWeb, :aliases

  def mount(socket) do
    {:ok, assign(socket, text: "")}
  end

  def render(assigns) do
    ~H"""
    <div id="message-form">
      <.form let={f} for={:message} phx-submit="send" phx-target={@myself}
          phx-change="form_change">
        <span class="input-duo">
          <%= text_input f, :text, value: @text,
                placeholder: "Enter your message..." %>
          <%= submit icon(%{class: "fa fa-comment fa-inverse"}),
                disabled: @text == "", title: "Send message" %>
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

  ## Private functions

  defp icon(assigns) do
    ~H"""
    <i class={@class}></i>
    """
  end
end
