defmodule Buzzword.Bingo.LiveView.ClientWeb.GameSizeFormComponent do
  use Buzzword.Bingo.LiveView.ClientWeb, :live_component
  use Buzzword.Bingo.LiveView.ClientWeb, :aliases

  def mount(socket) do
    changeset = GameSize.changeset()
    {:ok, assign(socket, changeset: changeset)}
  end

  def render(assigns) do
    ~H"""
    <div id="game-size-form">
      <.form
        let={f}
        for={@changeset}
        phx-change="validate"
        phx-submit="save"
        phx-target={@myself}
      >
        <%= text_input(f, :game_size,
          placeholder: "Game size",
          phx_hook: "AutoFocus",
          required: true
        ) %>
        <%= error_tag(f, :game_size) %>
        <%= submit("Save", phx_disable_with: "Saving...") %>
      </.form>
    </div>
    """
  end

  def handle_event("validate", %{"game_size" => game_size}, socket) do
    changeset = GameSize.changeset(game_size) |> struct(action: :insert)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"game_size" => game_size}, socket) do
    case GameSize.apply_insert(game_size) do
      {:ok, game_size} ->
        game_name = Engine.haiku_name()

        case Engine.new_game(game_name, game_size.game_size) do
          {:ok, _game_pid} ->
            game_path = Routes.game_path(socket, :show, game_name)
            {:noreply, push_patch(socket, to: game_path)}

          {:error, _error} ->
            {:noreply, put_flash(socket, :error, "Unable to start game!")}
        end

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
