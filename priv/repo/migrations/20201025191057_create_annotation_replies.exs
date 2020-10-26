defmodule Nota.Repo.Migrations.CreateAnnotationReplies do
  use Ecto.Migration

  @table :annotation_replies

  def change do
    create table(@table, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:text, :text)
      add(:user_id, references(:users, type: :uuid, on_delete: :nothing), null: false)
      add(:annotation_id, references(:annotations, type: :uuid, on_delete: :nothing), null: false)

      timestamps(type: :utc_datetime)
    end

    create(index(@table, [:user_id]))
    create(index(@table, [:annotation_id]))
  end
end
