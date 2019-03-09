defmodule Nota.Repo.Migrations.CreateVerses do
  use Ecto.Migration

  def change do
    create table(:verses, primary_key: false) do
      add :id, :integer, primary_key: true
      add :book, :string
      add :chapter, :string
      add :verse, :text
    end

  end
end
