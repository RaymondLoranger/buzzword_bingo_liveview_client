defmodule Buzzword.Bingo.LiveView.ClientWeb.UserFormComp do
  use Buzzword.Bingo.LiveView.ClientWeb, :live_component
  use Buzzword.Bingo.LiveView.ClientWeb, :aliases

  def mount(socket) do
    {:ok, assign(socket, :changeset, User.change(%User{}))}
  end

  def render(assigns) do
    # phx-target={@myself} would cause handle_info to lag in the liveview...
    ~H"""
    <div id="user-form">
      <.form let={f} for={@changeset} phx-change="validate" phx-submit="save">
        <%= text_input(f, :name, placeholder: "Name") %> <%= error_tag(f, :name) %>
        <%= text_input(f, :color, placeholder: "Color") %>
        <%= error_tag(f, :color) %>
        <%= submit("Save", phx_disable_with: "Saving...") %>
      </.form>
    </div>
    """
  end
end
