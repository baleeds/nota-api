defmodule Pets.Repo.Migrations.CreatePets do
  use Ecto.Migration

  def change do
    create table(:pets, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :breed, :string

      timestamps()
    end

  end
end
