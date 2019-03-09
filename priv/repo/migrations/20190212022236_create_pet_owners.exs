defmodule Pets.Repo.Migrations.CreatePetOwners do
  use Ecto.Migration

  @table :pet_owners

  def change do
    create table(@table, primary_key: false) do
      add(:pet_id, references(:pets, type: :uuid), null: false)
      add(:owner_id, references(:owners, type: :uuid), null: false)
    end

    create(index(@table, [:pet_id]))
    create(index(@table, [:owner_id]))

  end
end
