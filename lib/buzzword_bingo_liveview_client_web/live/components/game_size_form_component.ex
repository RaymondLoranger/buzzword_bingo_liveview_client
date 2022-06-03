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
      <.form let={f} for={@changeset} phx-change="validate" phx-submit="save"
          phx-target={@myself} class="w-2/3 mx-auto">
        <div class="flex flex-col">
          <div class="grid grid-cols-3 justify-between gap-x-24">
            <label>
              <%= radio_button f, :value, 5, checked: true,
                    phx_hook: "AutoFocus" %> 5 x 5
              <%= grid_glyph %{size: 5} %>
            </label>
            <label>
              <%= radio_button f, :value, 4 %> 4 x 4
              <%= grid_glyph %{size: 4} %>
            </label>
            <label>
              <%= radio_button f, :value, 3 %> 3 x 3
              <%= grid_glyph %{size: 3} %>
            </label>
          </div>
          <%= error_tag f, :value %>
        </div>
        <div class="text-center mt-6">
          <%= submit "Start Game",
                class: "border-2 px-4 py-2 border-gray-500 rounded-md" %>
        </div>
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

  ## Private functions

  defp grid_glyph(assigns) do
    ~H"""
    <div class={"grid grid-cols-#{@size} gap-2"}>
      <%= for _n <- 1..(@size * @size) do %>
        <div class="p-1 aspect-square bg-[#4f819c]"/>
      <% end %>
    </div>
    """
  end
end
