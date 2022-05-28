defmodule Buzzword.Bingo.LiveView.ClientWeb.UserFormComponent do
  use Buzzword.Bingo.LiveView.ClientWeb, :live_component
  use Buzzword.Bingo.LiveView.ClientWeb, :aliases

  @colors ["#a4deff", "#f9cedf", "#d3c5f1", "#acc9f5"] ++
            ["#aeeace", "#96d7b9", "#fce8bd", "#fcd8ac"]

  def mount(socket) do
    {:ok, assign(socket, color: hd(@colors), colors: @colors)}
  end

  def render(assigns) do
    ~H"""
    <div id="user-form">
      <h1>Welcome!</h1>
      <h4>First up, we need your name and favorite color:</h4>
      <.form let={f} for={@changeset} phx-change="validate" phx-submit="save"
          class="flex items-center">
        <%= text_input f, :name, placeholder: "Name", phx_debounce: "999",
              phx_hook: "AutoFocus", required: true %>
        <%= error_tag(f, :name) %>
        <ul class="grid grid-cols-8 gap-x-3 mx-4 max-w-md mx-auto">
          <%= for color <- @colors do %>
            <li class="relative">
              <%= radio_button f, :color, color, class: "sr-only peer",
                    phx_target: @myself, phx_click: "color_clicked",
                    id: color, checked: color == @color %>
              <label class={label_class(color)} for={color}/>
              <div class="color-checked">
                ✓
              </div>
            </li>
          <% end %>
        </ul>
        <%= submit("Save", phx_disable_with: "Saving...") %>
      </.form>
    </div>
    """
  end

  def handle_event("color_clicked", %{"value" => color}, socket) do
    {:noreply, assign(socket, color: color)}
  end

  ## Private functions

  defp label_class(color), do: "color bg-[#{color}]"
end
