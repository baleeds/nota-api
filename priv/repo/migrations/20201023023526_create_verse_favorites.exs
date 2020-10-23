defmodule Nota.Repo.Migrations.CreateVerseFavorites do
  use Ecto.Migration

  @table :verse_favorites

  def change do
    create table(@table, primary_key: false) do
      add(:id, :uuid, primary_key: true)

      add(:verse_id, references(:verses, type: :integer, on_delete: :nothing), null: false)
      add(:user_id, references(:users, type: :uuid, on_delete: :nothing), null: false)

      timestamps(type: :utc_datetime)
    end

    create(unique_index(@table, [:user_id, :verse_id]))

    create(index(@table, [:user_id]))
    create(index(@table, [:verse_id]))
  end
end
