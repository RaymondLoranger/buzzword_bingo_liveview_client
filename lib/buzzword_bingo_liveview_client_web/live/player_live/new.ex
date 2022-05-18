defmodule Buzzword.Bingo.Liveview.ClientWeb.PlayerLive.New do
  use Buzzword.Bingo.Liveview.ClientWeb, :live_view

  alias Buzzword.Bingo.LiveView.Client.User
  alias Buzzword.Bingo.Player

  @empty_form %{"user" => %{"name" => "", "color" => ""}}

  def mount(_params, _session, socket) do
    IO.inspect(%User{}, label: "--- %User{} ---")
    socket = assign(socket, :changeset, User.change(%User{}))
    socket = assign(socket, :player, nil)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-center bg-blue-100">Welcome to Buzzword Bingo!</h1>
    <.form
      let={f}
      for={@changeset}
      id="user-form"
      phx-change="validate"
      phx-submit="save"
    >
      <%= text_input(f, :name, placeholder: "Name", phx_debounce: "1000") %>
      <%= error_tag(f, :name) %>
      <%= text_input(f, :color, placeholder: "Color") %>
      <%= error_tag(f, :color) %>
      <%= submit("Save", phx_disable_with: "Saving...") %>
    </.form>
    """
  end

  def handle_event("validate", @empty_form, socket), do: {:noreply, socket}

  def handle_event("validate", %{"user" => user}, socket) do
    changeset =
      %User{}
      |> User.change(user)
      # Required to see validation errors...
      |> struct(action: :insert)
      |> IO.inspect(label: "~~~~~ changeset ~~~~~")

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => user}, socket) do
    IO.inspect(user, label: "***** user *****")
    player = Player.new(user["name"], user["color"])
    IO.inspect(player, label: "***** player *****")
    socket = assign(socket, :player, player)
    {:noreply, socket}
  end
end
