defmodule Nota.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  @table :users

  def change do
    create table(@table, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :first_name, :string
      add :last_name, :string

      add(:email, :string)
      # add(:password_hash, :string, null: false)

      add(:jti, :binary_id)

      # Omniauthable
      add(:oauth_provider, :string)
      add(:oauth_uid, :string)
      add(:oauth_token, :string)
      add(:oauth_refresh_token, :string)
      add(:oauth_expires_at, :integer)
      add(:oauth_expires, :boolean)

      # timestamps()
    end

    create(
      unique_index(@table, [:oauth_provider, :oauth_uid],
        name: :users_oauth_provider_oauth_uid_key
        # where: "deleted_at IS NULL"
      )
    )

    create(unique_index(@table, [:email], name: :users_email_key))
    # create(unique_index(@table, [:email], name: :users_email_key, where: "deleted_at IS NULL"))
    create(unique_index(@table, [:jti], name: :users_jti_key))
  end
end
