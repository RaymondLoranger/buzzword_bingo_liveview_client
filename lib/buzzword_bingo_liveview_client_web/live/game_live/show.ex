defmodule Buzzword.Bingo.Liveview.ClientWeb.GameLive.Show do
  use Buzzword.Bingo.Liveview.ClientWeb, :live_view

  def mount(params, session, socket) do
    IO.inspect(params, label: "[[[ params [[[")
    IO.inspect(session, label: "[[[ session [[[")
    {:ok, socket}
  end

  def handle_params(%{"id" => game_name}, _url, socket) do
    IO.inspect(game_name, label: "!!!!!! game_name !!!!!!")
    socket = assign(socket, :game_name, game_name)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-center bg-indigo-100">Play Game</h1>
    <p><%= IO.inspect(@game_name) %></p>
    """
  end

  # @spec game_show_path(Socket.t()) :: String.t()
  # "/games/:id"
  def game_show_path(socket, game_name) do
    Routes.game_show_path(socket, :show, game_name)
  end
end
