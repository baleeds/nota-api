defmodule Nota.Auth.RefreshToken do
  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type :binary_id
  schema "refresh_tokens" do
    field(:token, :string)
    field(:expires_at, :utc_datetime)

    belongs_to(:user, Nota.Auth.User)
  end

  def changeset(refresh_token, attrs) do
    refresh_token
    |> cast(attrs, [:user_id, :token, :expires_at])
    |> validate_required([:user_id, :token, :expires_at])
    |> foreign_key_constraint(:user_id)
    |> unique_constraint([:user_id, :token])
  end
end
