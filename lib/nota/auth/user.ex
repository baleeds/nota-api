defmodule Nota.Auth.User do
  use Ecto.Schema

  # alias Nota.Annotations.Annotation

  @required_fields ~w(
    first_name
    last_name
    email
    password
    password_hash
    jti
  )a

  @optional_fields ~w(
  )a
  
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "user" do
    field :first_name, :string
    field :last_name, :string

    # Authenticatable
    field(:email, Ecto.Email)
    field(:password, :string, virtual: true)
    field(:password_hash, :string, null: false, default: "")
    
    # JWT Authenticatable
    field(:jti, :binary_id, null: false)

    # has_many :annotations, Annotation
  end

  def changeset(%User{} = struct, attrs \\ %{}) do
    struct
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> validate_length(:first_name, min: 0, max: 255)
    |> validate_length(:last_name, min: 0, max: 255)
    |> validate_length(:email, min: 0, max: 255)
    |> validate_length(:password_hash, min: 0, max: 255)
    |> unique_constraint(:email, name: :users_email_key)
    |> unique_constraint(:jti, name: :users_jti_key)
  end
end