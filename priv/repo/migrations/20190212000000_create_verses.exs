defmodule Nota.Repo.Migrations.CreateVerses do
  use Ecto.Migration

  def change do
    create table(:verses, primary_key: false) do
      add :id, :integer, primary_key: true
      add :book_number, :integer
      add :chapter_number, :integer
      add :verse_number, :integer
      add :text, :text
    end

  end
end
