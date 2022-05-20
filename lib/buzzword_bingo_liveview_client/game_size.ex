defmodule Buzzword.Bingo.LiveView.Client.GameSize do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__

  @primary_key false

  embedded_schema do
    field :game_size, :integer
  end

  @doc false
  def changeset(game_size, attrs) do
    game_size
    |> cast(attrs, [:game_size])
    |> validate_inclusion(:game_size, 3..5, message: "must be 3 to 5")
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking changes.
  """
  def change(%GameSize{} = game_size, attrs \\ %{}) do
    changeset(game_size, attrs)
  end
end
