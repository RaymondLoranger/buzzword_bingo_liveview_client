defmodule Buzzword.Bingo.LiveView.Client.GameSize do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__

  @primary_key false

  embedded_schema do
    field :game_size, :integer, default: 3
  end

  def changeset(attrs \\ %{}) do
    %GameSize{}
    |> cast(attrs, [:game_size])
    |> validate_inclusion(:game_size, 3..5, message: "must be 3 to 5")
  end

  def apply_insert(attrs) do
    changeset(attrs) |> apply_action(:insert)
  end
end