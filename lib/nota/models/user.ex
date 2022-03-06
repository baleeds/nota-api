defmodule Nota.Models.User do
  use Ecto.Schema

  alias __MODULE__

  import Ecto.Changeset

  @required_fields ~w(
    email
  )a

  @optional_fields ~w(
    first_name
    last_name
    password
    password_hash
    oauth_provider
    oauth_uid
    oauth_token
    oauth_refresh_token
    oauth_expires_at
    oauth_expires
    jti
  )a

  @all_fields @required_fields ++ @optional_fields

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field(:first_name, :string)
    field(:last_name, :string)

    # Authenticatable
    field(:email, Ecto.Email)
    field(:password, :string, virtual: true)
    field(:password_hash, :string, null: false, default: "")

    # JWT Authenticatable
    field(:jti, :binary_id, null: false)

    # Omniauthable
    field(:oauth_provider, :string)
    field(:oauth_uid, :string)
    field(:oauth_token, :string)
    field(:oauth_refresh_token, :string)
    field(:oauth_expires_at, :integer)
    field(:oauth_expires, :boolean)

    field(:is_admin, :boolean, default: false)

    timestamps(type: :utc_datetime)
  end

  def changeset(%User{} = struct, attrs \\ %{}) do
    struct
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> validate_length(:first_name, min: 0, max: 50)
    |> validate_length(:last_name, min: 0, max: 50)
    |> validate_length(:email, min: 0, max: 50)
    |> validate_length(:password, min: 0, max: 255)
    |> validate_length(:password_hash, min: 0, max: 255)
    |> unique_constraint(:oauth_uid, name: :users_oauth_provider_oauth_uid_key)
    |> unique_constraint(:email,
      name: :users_email_key,
      message: "email already has an associated account"
    )
    |> unique_constraint(:jti, name: :users_jti_key)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end
end
