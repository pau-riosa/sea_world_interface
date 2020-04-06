defmodule SeaWorldInterface.SeaWorld.Channel do
  use Ecto.Schema
  import Ecto.Changeset
  alias SeaWorldInterface.Repo
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "channels" do
    field :name, :string
    has_one(:player1, SeaWorldInterface.SeaWorld.Player1)
    has_one(:player2, SeaWorldInterface.SeaWorld.Player2)
    timestamps()
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:name])
    |> cast_assoc(:player1)
    |> cast_assoc(:player2)
    |> validate_required([:name])
  end
end
