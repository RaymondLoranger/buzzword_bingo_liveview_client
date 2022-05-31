defmodule Buzzword.Bingo.LiveView.ClientWeb.MessageFormComponent do
  use Buzzword.Bingo.LiveView.ClientWeb, :live_component
  use Buzzword.Bingo.LiveView.ClientWeb, :aliases

  def mount(socket) do
    socket = assign(socket, message: "Enter a message...")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div id="game-size-form" class={@class}>
      <.form let={f} for={:message} phx-submit="send" phx-target={@myself}>
        <span>
          <%= text_input f, :message, value: @message %>
        </span>
        <span>
          <%= submit "Send", phx_disable_with: "Sending..." %>
        </span>
      </.form>
    </div>
    """
  end

  def handle_event("send", payload, socket) do
    IO.inspect(payload, label: "&&& payload in send event &&&")
    socket = assign(socket, message: "")
    {:noreply, socket}
  end
end
