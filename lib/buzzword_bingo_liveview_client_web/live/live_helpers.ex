defmodule Buzzword.Bingo.LiveView.ClientWeb.LiveHelpers do
  use Phoenix.Component

  def players(assigns) do
    ~H"""
    <div>
      <div>Who's Playing</div>
      <ul>
        <%= for {name, player} <- @players do %>
          <li>
            <span class={"h-2 w-2 px-2 mx-2 rounded-sm bg-[#{player.color}]"}>
            </span>
            <span><%= name %></span>
            <span><%= player.score %></span>
            <span>(<%= player.marked %> squares)</span>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end

  def square(assigns) do
    ~H"""
    <div
      class={square_class(@square.marked_by)}
      id={@square.phrase}
      phx-click="square_click"
      phx-value-id={@square.phrase}
      phx-target={@target}
    >
      <span><%= @square.phrase %></span>
      <span><%= @square.points %></span>
      <%= if @square.marked_by do %>
        <span class="font-bold"><%= @square.marked_by.name %></span>
      <% end %>
    </div>
    """
  end

  def squares(assigns) do
    ~H"""
    <div class={squares_class(@size)} id="squares" phx-update="append">
      <%= for square <- @squares do %>
        <%= render_slot(@inner_block, square) %>
      <% end %>
    </div>
    """
  end

  ## Private functions

  defp squares_class(size) do
    "grid grid-cols-#{size} gap-2 w-2/3 auto-rows-max auto-cols-max"
  end

  defp square_class(marked_by) when is_nil(marked_by), do: "square"
  defp square_class(marked_by), do: "square bg-[#{marked_by.color}]"
end
