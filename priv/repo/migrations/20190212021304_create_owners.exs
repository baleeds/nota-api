defmodule Nota.Repo.Migrations.CreateOwners do
  use Ecto.Migration

  def change do
    create table(:owners, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string

      timestamps()
    end

  end
end
