defmodule Buzzword.Bingo.LiveView.Client.User do
  use Ecto.Schema
  use PersistConfig

  import Ecto.Changeset

  alias __MODULE__

  @colors get_env(:player_colors)
  @max_players get_env(:max_players)
  @primary_key false

  embedded_schema do
    field :name, :string
    field :color, :string
  end

  def changeset(attrs \\ %{}, players \\ %{}) do
    %User{}
    |> cast(attrs, [:name, :color])
    |> validate_length(:name, min: 2, max: 9, message: "must be 2 to 9 chars")
    |> validate_change(:name, fn :name, name ->
      if players[name], do: [name: name_taken_msg(name)], else: []
    end)
    |> validate_change(:name, fn :name, _name ->
      if map_size(players) >= @max_players,
        do: [name: "players limit (#{@max_players}) already reached"],
        else: []
    end)
    |> validate_inclusion(:color, @colors, message: "invalid color")
    |> validate_change(:color, fn :color, color ->
      colors = players |> Map.values() |> Enum.map(& &1.color)
      if color in colors, do: [color: color_taken_msg(color)], else: []
    end)
  end

  def apply_insert(attrs, players) do
    changeset(attrs, players) |> apply_action(:insert)
  end

  ## Private functions

  defp name_taken_msg(name) do
    """
    name
    <span class="font-bold">
      #{name}
    </span>
    already taken
    """
  end

  defp color_taken_msg(color) do
    """
    color
    <span class="font-bold bg-[#{color}]">
      #{color}
    </span>
    already taken
    """
  end
end
