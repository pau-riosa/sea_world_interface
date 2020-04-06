defmodule SeaWorldInterface.SeaWorld.Player1 do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "player1" do
    field :name, :string
    belongs_to(:channel, SeaWorldInterface.SeaWorld.Channel)
    timestamps()
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
