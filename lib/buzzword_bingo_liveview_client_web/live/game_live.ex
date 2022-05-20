defmodule Buzzword.Bingo.LiveView.ClientWeb.GameLive do
  use Buzzword.Bingo.LiveView.ClientWeb, :live_view
  use Buzzword.Bingo.LiveView.ClientWeb, :aliases

  @empty_form %{"user" => %{"name" => "", "color" => ""}}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, return_to: nil, player: nil)}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def render(assigns) when assigns.live_action == :login do
    ~H"""
    <.live_component module={UserFormComp} id="user" return_to={@return_to} />
    """
  end

  def render(assigns) when assigns.live_action == :new do
    ~H"""
    <.live_component module={GameSizeFormComp} id="size" />
    """
  end

  def render(assigns) when assigns.live_action == :show do
    ~H"""
    <h1 class="text-center bg-indigo-200">Play Bingo</h1>
    """
  end

  def handle_event("validate", @empty_form, socket), do: {:noreply, socket}

  def handle_event("validate", %{"user" => user}, socket) do
    changeset = %User{} |> User.change(user) |> struct(action: :insert)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"user" => user}, socket) do
    socket = assign(socket, :player, Player.new(user["name"], user["color"]))
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end

  def handle_info({:new_game, game_name}, socket) do
    socket = assign(socket, :game_name, game_name)
    {:noreply, put_flash(socket, :info, "New game: #{game_name}")}
  end

  def handle_info(msg, socket) when is_binary(msg) do
    {:noreply, put_flash(socket, :error, msg)}
  end

  def handle_info(msg, socket) do
    {:noreply, put_flash(socket, :error, "#{inspect(msg)}")}
  end

  ## Private functions

  # "/games"
  defp apply_action(socket, :login, _params) do
    return_to = socket.assigns.return_to || Routes.game_path(socket, :new)
    assign(socket, page_title: "User info", return_to: return_to)
  end

  # "/games/new"
  defp apply_action(socket, :new, _params) when is_nil(socket.assigns.player) do
    # Player required...
    socket
    |> assign(:return_to, Routes.game_path(socket, :new))
    |> push_patch(to: Routes.game_path(socket, :login))
  end

  defp apply_action(socket, :new, _params) do
    assign(socket, :page_title, "Game size")
  end

  # "/games/:id"
  defp apply_action(socket, :show, %{"id" => game_name})
       when is_nil(socket.assigns.player) do
    # Player required
    socket
    |> assign(:return_to, Routes.game_path(socket, :show, game_name))
    |> push_patch(to: Routes.game_path(socket, :login))
  end

  defp apply_action(socket, :show, %{"id" => game_name}) do
    assign(socket, :page_title, "Game #{game_name}")
  end
end
