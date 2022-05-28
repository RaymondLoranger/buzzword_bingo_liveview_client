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
      <.form let={f} for={@changeset} phx-change="validate" phx-submit="save"
          class="flex items-center">
        <%= text_input f, :name, placeholder: "Name", phx_debounce: "999",
              autofocus: true, required: true %>
        <%= error_tag(f, :name) %>
        <ul class="grid grid-cols-8 gap-x-3 mx-4 max-w-md mx-auto">
          <%= for color <- @colors do %>
            <li class="relative">
              <%= radio_button f, :color, color, class: "sr-only peer",
                    checked: color == @color, phx_click: "color_clicked",
                    phx_change: "color_changed", phx_target: @myself,
                    id: color %>
              <label class={label_class(color)} for={color}/>
              <div class="color-checked">
                ✔
              </div>
            </li>
          <% end %>
        </ul>
        <%= submit("Save", phx_disable_with: "Saving...") %>
      </.form>
    </div>
    """
  end

  def handle_event("color_changed", pl, socket) do
    IO.inspect(socket.assigns, label: "((( socket.assigns in color_changed )))")
    IO.inspect(pl, label: "((( payload )))")
    {:noreply, socket}
  end

  def handle_event("color_clicked", pl, socket) do
    IO.inspect(socket.assigns, label: "((( socket.assigns in color_clicked )))")
    IO.inspect(pl, label: "((( payload )))")
    {:noreply, socket}
  end

  ## Private functions

  defp label_class(color) do
    "flex p-5 bg-[#{color}] rounded-md cursor-pointer peer-checked:ring-2"
  end

  # defp color_li(color, checked?) do
  #   """
  #   <li>
  #     <input class="sr-only peer" type="radio" value=#{color} name="color"
  #         id=#{color} #{if checked?, do: "checked"} />
  #     <label class="#{label_class(color)}" for=#{color} />
  #   </li>
  #   """
  #   |> Phoenix.HTML.raw()
  # end
end
