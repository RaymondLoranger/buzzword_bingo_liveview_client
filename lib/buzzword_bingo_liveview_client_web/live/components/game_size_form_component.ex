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
      <div class="flex justify-center mb-8">
        <h4 class="text-xl">Select the game size:</h4>
      </div>
      <.form let={f} for={@changeset} phx-change="validate" phx-submit="start"
          phx-target={@myself} class="w-2/3 mx-auto">
        <div class="flex flex-col">
          <div class="grid grid-cols-3 gap-x-24">
            <label>
              <%= radio_button f, :value, 5, checked: true,
                    phx_hook: "AutoFocus", class: "ml-12 mb-4" %>
              <.grid_size>5 x 5</.grid_size>
              <.grid_glyph size={5}/>
            </label>
            <label>
              <%= radio_button f, :value, 4, class: "ml-12 mb-4" %>
              <.grid_size>4 x 4</.grid_size>
              <.grid_glyph size={4}/>
            </label>
            <label>
              <%= radio_button f, :value, 3, class: "ml-12 mb-4" %>
              <.grid_size>3 x 3</.grid_size>
              <.grid_glyph size={3}/>
            </label>
          </div>
          <%= error_tag f, :value %>
        </div>
        <div class="text-center mt-6">
          <%= submit "Start Game", class: "submit-button" %>
        </div>
      </.form>
    </div>
    """
  end

  def handle_event("validate", %{"game_size" => game_size}, socket) do
    changeset = GameSize.changeset(game_size) |> struct(action: :insert)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("start", %{"game_size" => game_size}, socket) do
    case GameSize.apply_insert(game_size) do
      {:ok, game_size} ->
        game_name = Engine.haiku_name()

        case Engine.new_game(game_name, game_size.value) do
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
