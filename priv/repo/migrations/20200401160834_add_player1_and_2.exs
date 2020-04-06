defmodule SeaWorldInterface.Repo.Migrations.AddPlayer1And2 do
  use Ecto.Migration

  def change do
    create table(:player1, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :channel_id, references(:channels, type: :binary_id)
      timestamps()
    end

    create table(:player2, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :channel_id, references(:channels, type: :binary_id)
      timestamps()
    end
  end
end
