defmodule Buzzword.Bingo.LiveView.Client.GameSize do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__

  @game_size_message "Must be between 3 and 5"
  @required "Can't be blank"
  @primary_key false

  embedded_schema do
    field :game_size, :integer
  end

  @doc false
  def changeset(game_size, attrs) do
    game_size
    |> cast(attrs, [:game_size])
    |> validate_required([:game_size], message: @required)
    |> validate_inclusion(:game_size, 3..5, message: @game_size_message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking changes.
  """
  def change(%GameSize{} = game_size, attrs \\ %{}) do
    changeset(game_size, attrs)
  end
end
