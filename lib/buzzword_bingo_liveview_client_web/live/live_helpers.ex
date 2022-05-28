defmodule Buzzword.Bingo.LiveView.ClientWeb.LiveHelpers do
  use Phoenix.Component

  def players(assigns) do
    ~H"""
    <div>
      <div>Who's Playing</div>
      <ul>
        <%= for {name, player} <- @players do %>
          <li>
            <span class={player_mark(player)}/>
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
    <div class={square_class(@square)} id={@square.phrase} phx-target={@target}
        phx-click="square_click" phx-value-id={@square.phrase}>
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
    <div class={squares_class(@game_size)} id="squares" phx-update="append">
      <%= for square <- @squares do %>
        <%= render_slot(@inner_block, square) %>
      <% end %>
    </div>
    """
  end

  ## Private functions

  defp squares_class(game_size) do
    "squares grid-cols-#{game_size}"
  end

  defp square_class(square) when is_nil(square.marked_by), do: "square"
  defp square_class(square), do: "square bg-[#{square.marked_by.color}]"

  defp player_mark(player), do: "player-mark bg-[#{player.color}]"
end
