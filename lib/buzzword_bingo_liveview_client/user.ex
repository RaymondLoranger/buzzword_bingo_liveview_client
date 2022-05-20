defmodule Buzzword.Bingo.LiveView.Client.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__

  @colors [
    "#a4deff",
    "#f9cedf",
    "#d3c5f1",
    "#acc9f5",
    "#aeeace",
    "#96d7b9",
    "#fce8bd",
    "#fcd8ac",
    "blue",
    "yellow",
    "green",
    "cyan",
    "indigo"
  ]
  @primary_key false

  embedded_schema do
    field :name, :string
    field :color, :string
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :color])
    |> validate_required([:name, :color])
    |> validate_length(:name, min: 2, max: 9, message: "must be 2 to 9 chars")
    |> validate_inclusion(:color, @colors, message: "invalid color")
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking changes.
  """
  def change(%User{} = user, attrs \\ %{}) do
    changeset(user, attrs)
  end
end
