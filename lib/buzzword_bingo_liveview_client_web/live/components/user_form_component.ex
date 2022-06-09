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
    <div id="user-form" class="container mx-auto flex flex-col items-center">
      <h1 class="mt-8 mb-2 text-4xl text-cool-gray-900">Welcome!</h1>
      <h4 class="m-2 text-xl font-thin text-cool-gray-900">
        First up, we need your name and favorite color:
      </h4>
      <.form let={f} for={@changeset} phx-change="validate" phx-submit="play"
          class="flex flex-col items-center gap-4">
        <div class="fields">
          <div class="flex flex-col h-16">
            <%= text_input f, :name, placeholder: "Name", phx_debounce: "500",
                  phx_hook: "AutoFocus", required: true, class: name(@color) %>
            <%= error_tag f, :name, class: "invalid-feedback pl-2" %>
          </div>
          <div class="flex flex-col h-16">
            <ul class="flex gap-1.5">
              <%= for color <- @colors do %>
                <li class="relative">
                  <label title={color} class={color_square(color)}>
                    <%= radio_button f, :color, color, class: "sr-only peer",
                          phx_target: @myself, phx_click: "color_clicked",
                          checked: color == @color %>
                    <span class={peer_checked()}>✓</span>
                  </label>
                </li>
              <% end %>
            </ul>
            <%= error_tag f, :color, class: "invalid-feedback pl-0.5" %>
          </div>
        </div>
        <%= submit "Play Bingo!", class: "submit-button" %>
      </.form>
    </div>
    """
  end

  def handle_event("color_clicked", %{"value" => color}, socket) do
    {:noreply, assign(socket, color: color)}
  end

  ## Private functions

  defp name(color) do
    "name border-[#{color}]"
  end

  defp color_square(color) do
    "color-square bg-[#{color}]"
  end

  defp peer_checked do
    "absolute hidden peer-checked:block top-0.5 left-2"
  end
end
