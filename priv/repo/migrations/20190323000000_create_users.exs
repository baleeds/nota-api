defmodule Nota.Repo.Migrations.CreateAnnotation do
  use Ecto.Migration

  @table :users

  def change do
    create table(@table, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :first_name, :string
      add :last_name, :string

      add(:email, :string)
      add(:password_hash, :string, null: false)

      add(:jti, :binary_id, null: false, default: fragment("gen_random_uuid()"))

      timestamps()
    end

    create(unique_index(@table, [:email], name: :users_email_key))
    # create(unique_index(@table, [:email], name: :users_email_key, where: "deleted_at IS NULL"))
    create(unique_index(@table, [:jti], name: :users_jti_key))
  end
end
