defmodule Buzzword.Bingo.LiveView.ClientWeb.UserFormComponent do
  use Buzzword.Bingo.LiveView.ClientWeb, :live_component
  use Buzzword.Bingo.LiveView.ClientWeb, :aliases

  def render(assigns) do
    ~H"""
    <div id="user-form">
      <.form let={f} for={@changeset} phx-change="validate" phx-submit="save">
        <%= text_input(f, :name,
          placeholder: "Name",
          phx_debounce: "999",
          autofocus: true,
          required: true
        ) %>
        <%= error_tag(f, :name) %>
        <%= text_input(f, :color,
          placeholder: "Color",
          phx_debounce: "999",
          required: true
        ) %>
        <%= error_tag(f, :color) %>
        <%= submit("Save", phx_disable_with: "Saving...") %>
      </.form>
    </div>
    """
  end
end
