defmodule Buzzword.Bingo.LiveView.ClientWeb.UserFormComponent do
  use Buzzword.Bingo.LiveView.ClientWeb, :live_component
  use Buzzword.Bingo.LiveView.ClientWeb, :aliases

  def render(assigns) do
    ~H"""
    <div id="user-form">
      <.form
        let={f}
        for={@changeset}
        phx-change="validate"
        phx-submit="save"
        class="flex items-center"
      >
        <%= text_input(f, :name,
          placeholder: "Name",
          phx_debounce: "999",
          autofocus: true,
          required: true
        ) %>
        <%= error_tag(f, :name) %>
        <ul class="grid grid-cols-8 gap-x-3 mx-4 max-w-md mx-auto">
          <li class="relative">
            <input
              class="sr-only peer"
              type="radio"
              value="#a4deff"
              name="color"
              id="#a4deff"
            />
            <label class={label_class("#a4deff")} for="#a4deff" />
            <div class="absolute hidden w-5 h-5 peer-checked:block top-2 right-3 text-2xl">
              ✓
            </div>
          </li>

          <li>
            <input
              class="sr-only peer"
              type="radio"
              value="#f9cedf"
              name="color"
              id="#f9cedf"
            />
            <label
              class="flex p-5 bg-[#f9cedf] rounded-md cursor-pointer
              peer-checked:ring-2"
              for="#f9cedf"
            >
            </label>
          </li>
          <%= color_li("#d3c5f1", false) %>
          <%= color_li("#acc9f5", true) %>
          <%= color_li("#accacc", true) %>
        </ul>
        <%= error_tag(f, :color) %>
        <%= submit("Save", phx_disable_with: "Saving...") %>
      </.form>
      <span hidden class="bg-[#a4deff]" />
      <span hidden class="bg-[#f9cedf]" />
      <span hidden class="bg-[#d3c5f1]" />
      <span hidden class="bg-[#acc9f5]" />
      <span hidden class="bg-[#aeeace]" />
      <span hidden class="bg-[#96d7b9]" />
      <span hidden class="bg-[#fce8bd]" />
      <span hidden class="bg-[#fcd8ac]" />
      <span hidden class="bg-[blue]" />
      <span hidden class="bg-[green]" />
      <span hidden class="bg-[red]" />
      <span hidden class="bg-[yellow]" />
      <span hidden class="bg-[orange]" />
    </div>
    """
  end

  ## Private functions

  defp label_class(color) do
    "flex p-5 bg-[#{color}] rounded-md cursor-pointer peer-checked:ring-2"
  end

  defp color_li(color, checked?) do
    """
    <li>
      <input class="sr-only peer" type="radio" value=#{color} name="color"
          id=#{color} #{if checked?, do: "checked"} />
      <label class="#{label_class(color)}" for=#{color} />
    </li>
    """
    |> Phoenix.HTML.raw()
  end
end
