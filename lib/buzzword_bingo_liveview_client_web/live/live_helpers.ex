defmodule Buzzword.Bingo.LiveView.ClientWeb.LiveHelpers do
  use Phoenix.Component
  use Buzzword.Bingo.LiveView.ClientWeb, :aliases

  def grid_size(assigns) do
    ~H"""
    <span class="leading-4 float-right mr-12">
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

  def grid_glyph(assigns) do
    ~H"""
    <div class={"grid grid-cols-#{@size} gap-2"}>
      <%= for _n <- 1..(@size * @size) do %>
        <div class="p-1 aspect-square bg-[#4f819c]"/>
      <% end %>
    </div>
    """
  end

  def players(assigns) do
    ~H"""
    <div id="players-panel">
      <div class="text-white bg-[#8064A2] p-2 rounded-t-md">
        Who's Playing
      </div>
      <div class="p-0">
        <ul id="players" class="players" phx-update="replace">
          <%= for {name, player} <- @players do %>
            <li class="border-b-[1px] border-gray-200 p-1">
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
    <div id="messages-panel">
      <div class="text-white bg-[#8064A2] p-2 rounded-t-md">
        What's Up?
      </div>
      <div>
        <ul id="messages" phx-update="append" phx-hook="ScrollToEnd"
            class={messages_class(@presences)}>
          <%= for %{id: id, text: text, sender: sender} <- @messages do %>
            <li id={id} class="border-b-[1px] border-gray-200 p-1">
              <span class={message_class(sender)}>
                <%= sender.name %>
              </span>
              <span><%= text %></span>
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
      <span class="font-bold"><%= marked_by(@square.marked_by) %></span>
      <span class="h-2/3 text-sm"><%= @square.phrase %></span>
      <span><%= @square.points %></span>
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

  def game_over?(assigns) do
    ~H"""
    <%= if @winner do %>
      <div id="winner" class="winner">
        <%= @winner.name %> won!
      </div>
    <% end %>
    """
  end

  def game_url(assigns) do
    ~H"""
    <div class="input-duo mt-2 mb-8 mx-auto">
      <input id="game-url" type="text" value={@url} readonly class="game-url">
      <button title="Copy game URL" phx-click="url_click" phx-target={@target}>
        <Solid.clipboard_copy class="h-full aspect-square invert"/>
      </button>
    </div>
    """
  end

  ## Private functions

  defp messages_class(_presences = 0) do
    "messages lg:h-[393px] md:h-[263x]"
  end

  defp messages_class(1) do
    "messages lg:h-[393px] md:h-[263px]"
  end

  defp messages_class(2) do
    "messages lg:h-[360px] md:h-[231px]"
  end

  defp messages_class(3) do
    "messages lg:h-[328px] md:h-[198px]"
  end

  defp messages_class(4) do
    "messages lg:h-[294px] md:h-[165px]"
  end

  defp message_class(sender) do
    "bg-[#{sender.color}] pl-1.5 pr-0.5 mr-1 rounded-sm"
  end

  defp squares_class(game_size) do
    "squares grid-cols-#{game_size}"
  end

  defp square_class(square) when is_nil(square.marked_by), do: "square bg-white"
  defp square_class(square), do: "square bg-[#{square.marked_by.color}]"

  defp marked_by(player) when is_nil(player), do: ""
  defp marked_by(player), do: player.name

  defp player_mark(player), do: "player-mark bg-[#{player.color}]"
end
