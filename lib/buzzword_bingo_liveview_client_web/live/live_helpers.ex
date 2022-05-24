defmodule Buzzword.Bingo.LiveView.ClientWeb.LiveHelpers do
  use Phoenix.Component

  def players(assigns) do
    ~H"""
    <div>
      <div>Who's Playing</div>
      <ul>
        <%= for player <- @players do %>
          <li><%= player.name %> - <%= player.color %></li>
        <% end %>
      </ul>
    </div>
    """
  end

  def square(assigns) do
    ~H"""
    <div
      class="flex flex-col border-2 border-indigo-200 rounded-md w-full h-24
      p-2 text-indigo-700 text-xs leading-3"
      id={@square.phrase}
      phx-click="square-click"
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

  defp squares_class(3) do
    "grid grid-cols-3 gap-2 w-5/12 auto-rows-max auto-cols-max"
  end

  defp squares_class(4) do
    "grid grid-cols-4 gap-2 w-7/12 auto-rows-max auto-cols-max"
  end

  defp squares_class(5) do
    "grid grid-cols-5 gap-2 w-8/12 auto-rows-max auto-cols-max"
  end
end
