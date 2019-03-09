defmodule Nota.Repo.Migrations.CreateAnnotation do
  use Ecto.Migration

  def change do
    create table(:annotation, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :text, :text
      add :verse_id, references(:verses, type: :integer), null: false

      timestamps()
    end

  end
end
