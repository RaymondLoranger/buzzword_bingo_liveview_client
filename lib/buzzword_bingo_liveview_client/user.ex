defmodule Buzzword.Bingo.LiveView.Client.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__

  @primary_key false

  embedded_schema do
    field :name, :string
    field :color, :string
  end

  @doc false
  def changeset(user, attrs) do
    # IO.inspect(user, label: "&&& user &&&")
    # IO.inspect(attrs, label: "&&& attrs &&&")
    user
    |> cast(attrs, [:name, :color])
    |> validate_required([:name, :color])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking changes.
  """
  def change(%User{} = user, attrs \\ %{}) do
    changeset(user, attrs)
  end
end
