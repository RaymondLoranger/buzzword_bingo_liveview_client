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
    field :color, :string, default: hd(@colors)
  end

  def changeset(attrs \\ %{}, players \\ %{}) do
    %User{}
    |> cast(attrs, [:name, :color])
    |> validate_length(:name, min: 2, max: 9, message: "must be 2 to 9 chars")
    |> validate_change(:name, fn :name, name ->
      if players[name], do: [name: "Name '#{name}' already taken"], else: []
    end)
    |> validate_change(:name, fn :name, _name ->
      if map_size(players) >= @max_players,
        do: [name: "Max number of players (#{@max_players}) already reached"],
        else: []
    end)
    |> validate_inclusion(:color, @colors, message: "invalid color")
  end

  def apply_insert(attrs, players) do
    changeset(attrs, players) |> apply_action(:insert)
  end
end
