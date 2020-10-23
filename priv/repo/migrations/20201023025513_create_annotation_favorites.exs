defmodule Nota.Repo.Migrations.CreateAnnotationFavorites do
  use Ecto.Migration

  @table :annotation_favorites

  def change do
    create table(@table, primary_key: false) do
      add(:id, :uuid, primary_key: true)

      add(:user_id, references(:users, type: :uuid, on_delete: :nothing), null: false)
      add(:annotation_id, references(:annotations, type: :uuid, on_delete: :nothing), null: false)

      timestamps(type: :utc_datetime)
    end

    create(unique_index(@table, [:user_id, :annotation_id]))

    create(index(@table, [:user_id]))
    create(index(@table, [:annotation_id]))
  end
end
