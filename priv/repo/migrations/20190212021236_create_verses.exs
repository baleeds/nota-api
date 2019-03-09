defmodule Nota.Repo.Migrations.CreateVerses do
  use Ecto.Migration

  def change do
    create table(:verses, primary_key: false) do
      add :id, :integer, primary_key: true
      add :book, :integer
      add :chapter, :integer
      add :verse, :integer
      add :text, :text
    end

  end
end
