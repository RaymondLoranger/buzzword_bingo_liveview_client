defmodule Buzzword.Bingo.LiveView.ClientWeb.GameSizeFormComp do
  use Buzzword.Bingo.LiveView.ClientWeb, :live_component
  use Buzzword.Bingo.LiveView.ClientWeb, :aliases

  @empty_form %{"game_size" => %{"game_size" => ""}}

  def mount(socket) do
    socket = assign(socket, :changeset, GameSize.change(%GameSize{}))
    {:ok, socket}
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
        <%= text_input(f, :game_size, placeholder: "Game size") %>
        <%= error_tag(f, :game_size) %>
        <%= submit("Save", phx_disable_with: "Saving...") %>
      </.form>
    </div>
    """
  end

  def handle_event("validate", @empty_form, socket), do: {:noreply, socket}

  def handle_event("validate", %{"game_size" => size}, socket) do
    changeset = %GameSize{} |> GameSize.change(size) |> struct(action: :insert)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"game_size" => size}, socket) do
    game_name = Engine.haiku_name()
    size = String.to_integer(size["game_size"])

    case Engine.new_game(game_name, size) do
      {:ok, _game_pid} ->
        send(self(), {:new_game, game_name})

        {:noreply,
         push_patch(socket, to: Routes.game_path(socket, :show, game_name))}

      {:error, _error} ->
        {:noreply, put_flash(socket, :error, "Unable to start game!")}
    end
  end
end
