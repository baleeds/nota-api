defmodule Nota.Services.Auth.Tx.ResetPassword do
  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Nota.Models.{User, RefreshToken, ResetPasswordToken}
  alias Nota.Helpers
  alias Nota.Services.Email
  alias Nota.Mailer

  def call(token, new_password) do
    Multi.new()
    |> Helpers.Multi.add(:token, token)
    |> Helpers.Multi.add(:password, new_password)
    |> Multi.run(:reset_password_token, &get_reset_password_token_tx/2)
    |> Multi.run(:user, &get_user_tx/2)
    |> Multi.run(:is_logged_out, &logout_tx/2)
    |> Multi.run(:updated_user, &update_password_tx/2)
    |> Multi.run(:is_email_sent, &send_success_email_tx/2)
  end

  defp get_reset_password_token_tx(repo, %{token: token}) do
    ResetPasswordToken
    |> where([r], r.token == ^token and r.expires_at > ^DateTime.utc_now())
    |> repo.one()
    |> case do
      nil -> {:error, "It looks like this reset request has expired."}
      reset_password_token -> {:ok, reset_password_token}
    end
  end

  defp get_user_tx(repo, %{reset_password_token: %{user_id: user_id}}) do
    User
    |> where(id: ^user_id)
    |> repo.one()
    |> case do
      nil -> {:error, "This token is invalid"}
      user -> {:ok, user}
    end
  end

  defp logout_tx(repo, %{user: %{id: user_id}}) do
    RefreshToken
    |> where(user_id: ^user_id)
    |> repo.delete_all()
    |> case do
      {:error, _} -> {:error, "User could not be logged out"}
      _ -> {:ok, true}
    end
  end

  defp update_password_tx(repo, %{user: user, password: password}) do
    user
    |> User.changeset(%{password: password})
    |> repo.update()
  end

  defp send_success_email_tx(_repo, %{user: user}) do
    Email.password_changed(user)
    |> Mailer.deliver_later()

    {:ok, true}
  end
end
