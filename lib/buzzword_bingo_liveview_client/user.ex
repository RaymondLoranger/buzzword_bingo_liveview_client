defmodule Buzzword.Bingo.LiveView.Client.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__

  @colors ["#a4deff", "#f9cedf", "#d3c5f1", "#acc9f5"] ++
            ["#aeeace", "#96d7b9", "#fce8bd", "#fcd8ac"]
  @primary_key false

  embedded_schema do
    field :name, :string
    field :color, :string, default: List.first(@colors)
  end

  def changeset(attrs \\ %{}) do
    %User{}
    |> cast(attrs, [:name, :color])
    |> validate_length(:name, min: 2, max: 9, message: "must be 2 to 9 chars")
    |> validate_inclusion(:color, @colors, message: "invalid color")
  end

  def apply_insert(attrs) do
    changeset(attrs) |> apply_action(:insert)
  end
end
