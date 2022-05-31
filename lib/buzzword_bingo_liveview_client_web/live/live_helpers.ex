defmodule Buzzword.Bingo.LiveView.ClientWeb.LiveHelpers do
  use Phoenix.Component

  def players(assigns) do
    ~H"""
    <div>
      <div class="text-white bg-[#8064A2]">Who's Playing</div>
      <div class="p-0">
        <ul id="players" class="mb-0 bg-white" phx-update="replace">
          <%= for {name, player} <- @players do %>
            <li class="border-b-[1px] border-gray-200">
              <span class={player_mark(player)}/>
              <span><%= name %></span>
              <span><%= player.score %></span>
              <span>(<%= player.marked %> squares)</span>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end

  def messages(assigns) do
    ~H"""
    <div class={@class}>
      <div class="text-white bg-[#8064A2]">What's Up?</div>
      <div class="p-0">
        <ul id="messages" class="mb-0 bg-white" phx-update="append">
          <%= for %{id: id, sender: sender, body: body} <- @messages do %>
            <li id={id} class="border-b-[1px] border-gray-200">
              <span><%= sender %></span>
              <span><%= body %></span>
            </li>
          <% end %>
        </ul>
      </div>
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
