defmodule Nota.Auth.Tx.SendForgotPassword do
  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Nota.Auth.User
  alias Nota.Auth.ResetPasswordToken
  alias Nota.Helpers

  def call(email) do
    Multi.new()
    |> Helpers.Multi.add(:email, email)
    |> Multi.run(:user, &get_user_tx/2)
    |> Multi.run(:deleted_tokens, &delete_previous_tokens_tx/2)
    |> Multi.run(:reset_password_token, &create_reset_password_token_tx/2)
    |> Multi.run(:is_email_sent, &send_reset_email_tx/2)
  end

  defp get_user_tx(repo, %{email: email}) do
    User
    |> where(email: ^email)
    |> repo.one()
    |> case do
      nil -> {:error, :suppress}
      user -> {:ok, user}
    end
  end

  defp delete_previous_tokens_tx(repo, %{user: %{id: user_id}}) do
    ResetPasswordToken
    |> where(user_id: ^user_id)
    |> repo.delete_all()
    |> case do
      {:error, _} -> {:error, :unknown}
      _ -> {:ok, true}
    end
  end

  defp create_reset_password_token_tx(repo, %{user: %{id: user_id}}) do
    token = SecureRandom.urlsafe_base64()
    expires_at = DateTime.add(DateTime.utc_now(), 30 * 60, :second)

    %ResetPasswordToken{}
    |> ResetPasswordToken.changeset(%{
      user_id: user_id,
      token: token,
      expires_at: expires_at
    })
    |> repo.insert()
  end

  defp send_reset_email_tx(_repo, %{user: user, reset_password_token: reset_password_token}) do
    Nota.Email.reset_password(user, reset_password_token)
    |> Nota.Mailer.deliver_later()

    {:ok, true}
  end
end
