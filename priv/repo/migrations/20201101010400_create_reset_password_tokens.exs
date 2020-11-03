defmodule Nota.Repo.Migrations.CreateResetPasswordToken do
  use Ecto.Migration

  @table :reset_password_tokens

  def change do
    create table(@table, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:token, :string, size: 64, null: false)
      add(:user_id, references(:users, type: :uuid, on_delete: :nothing), null: false)
      add(:expires_at, :utc_datetime, null: false)
    end

    create(unique_index(@table, :user_id))
    create(unique_index(@table, :token))
    create(index(@table, :expires_at))
  end
end
