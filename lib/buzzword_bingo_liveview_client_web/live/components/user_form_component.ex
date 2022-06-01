defmodule Buzzword.Bingo.LiveView.ClientWeb.UserFormComponent do
  use Buzzword.Bingo.LiveView.ClientWeb, :live_component
  use Buzzword.Bingo.LiveView.ClientWeb, :aliases
  use PersistConfig

  @colors get_env(:player_colors)

  def mount(socket) do
    {:ok, assign(socket, color: hd(@colors), colors: @colors)}
  end

  def render(assigns) do
    ~H"""
    <div id="user-form">
      <h1>Welcome!</h1>
      <h4>First up, we need your name and favorite color:</h4>
      <.form let={f} for={@changeset} phx-change="validate" phx-submit="save"
          class="flex items-top">
        <div class="flex flex-col">
          <%= text_input f, :name, placeholder: "Name", phx_debounce: "999",
                phx_hook: "AutoFocus", required: true %>
          <%= error_tag f, :name %>
        </div>
        <div class="flex flex-col ml-8">
          <ul class="grid grid-cols-8 gap-x-2 max-w-md mx-auto">
            <%= for color <- @colors do %>
              <li class="relative">
                <%= radio_button f, :color, color, class: "sr-only peer",
                      phx_target: @myself, phx_click: "color_clicked",
                      id: color, checked: color == @color %>
                <label class={label_class(color)} for={color}/>
                <div class="color-checked">✓</div>
              </li>
            <% end %>
          </ul>
          <%= error_tag f, :color %>
        </div>
        <div>
          <%= submit "Play Bingo" %>
        </div>
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
