defmodule Buzzword.Bingo.LiveView.Client.GameSize do
  use Ecto.Schema
  use PersistConfig

  import Ecto.Changeset

  alias __MODULE__

  @sizes get_env(:game_sizes)
  @min @sizes.first
  @max @sizes.last
  @primary_key false

  embedded_schema do
    field :value, :integer, default: 3
  end

  def changeset(attrs \\ %{}) do
    %GameSize{}
    |> cast(attrs, [:value])
    |> validate_inclusion(:value, @sizes, message: "must be #{@min} to #{@max}")
  end

  def apply_insert(attrs) do
    changeset(attrs) |> apply_action(:insert)
  end
end
