defmodule Buzzword.Bingo.Liveview.ClientWeb.GameLive.New do
  use Buzzword.Bingo.Liveview.ClientWeb, :live_view

  alias Buzzword.Bingo.LiveView.Client.GameSize
  alias Buzzword.Bingo.Engine

  @empty_form %{"game_size" => %{"game_size" => ""}}

  def mount(_params, _session, socket) do
    IO.inspect(%GameSize{}, label: "--- %GameSize{} ---")
    socket = assign(socket, :changeset, GameSize.change(%GameSize{}))
    socket = assign(socket, :game_size, nil)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-center bg-pink-100">Create Game</h1>
    <.form
      let={f}
      for={@changeset}
      id="game-size-form"
      phx-change="validate"
      phx-submit="save"
    >
      <%= text_input(f, :game_size, placeholder: "Game size") %>
      <%= error_tag(f, :game_size) %>
      <%= submit("Save", phx_disable_with: "Saving...") %>
    </.form>
    """
  end

  def handle_event("validate", @empty_form, socket), do: {:noreply, socket}

  def handle_event("validate", %{"game_size" => game_size}, socket) do
    changeset =
      %GameSize{}
      |> GameSize.change(game_size)
      # Required to see validation errors...
      |> struct(action: :insert)
      |> IO.inspect(label: "^^^^^ changeset ^^^^^")

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"game_size" => game_size}, socket) do
    IO.inspect(game_size, label: "%%%%% game_size %%%%%")

    game_name = Engine.haiku_name()
    size = String.to_integer(game_size["game_size"])

    case Engine.new_game(game_name, size) do
      {:ok, game_pid} ->
        IO.inspect(game_pid, label: "::: game_pid:::")
        socket = assign(socket, :game_pid, game_pid)
        path = Routes.game_show_path(socket, :show, game_name)
        IO.inspect(path, label: "++++ path ++++")
        {:noreply, push_redirect(socket, to: Routes.game_show_path(socket, :show, game_name))}

      {:error, error} ->
        IO.inspect(error, label: "::: error:::")
        {:noreply, socket}
    end

  end
end
