defmodule Nota.Repo.Migrations.CreateRefreshTokens do
  use Ecto.Migration

  @table :refresh_tokens

  def change do
    create table(@table) do
      add(:user_id, references(:users, type: :uuid, on_delete: :nothing), null: false)
      add(:token, :string, null: false, size: 1024)
      add(:expires_at, :utc_datetime, null: false)
    end

    create(unique_index(@table, [:user_id, :token]))

    create(index(@table, [:user_id]))
    create(index(@table, [:token]))
    create(index(@table, [:expires_at]))
  end
end
