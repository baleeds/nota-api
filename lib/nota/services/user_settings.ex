defmodule Nota.Services.UserSettings do
  import Ecto.Query, warn: false

  alias Nota.Repo
  alias Nota.Models.User
  alias Nota.Services.Auth

  def change_password(user_id, old_password, new_password) do
    User
    |> where(id: ^user_id)
    |> Repo.one()
    |> case do
      nil ->
        {:error, :unknown}

      user ->
        if Argon2.verify_pass(old_password, user.password_hash) do
          user
          |> User.changeset(%{password: new_password})
          |> Repo.update()
          |> case do
            {:ok, _user} -> {:ok, true}
            {:error, error} -> {:error, error}
          end
        else
          {:error, :invalid_password}
        end
    end
  end

  def change_display_name(user_id, first_name, last_name) do
    Auth.update_user_by_id(user_id, %{first_name: first_name, last_name: last_name})
    |> case do
      {:ok, user} -> {:ok, user}
      {:error, error} -> {:error, error}
    end
  end
end
