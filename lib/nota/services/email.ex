defmodule Nota.Services.Email do
  import Bamboo.Email

  alias Nota.Models.{User, ResetPasswordToken}

  def frontend_url do
    Application.fetch_env!(:nota, :frontend_url)
  end

  def reset_password(%User{email: email}, %ResetPasswordToken{token: token}) do
    base_email()
    |> to(email)
    |> subject("Reset Password")
    |> html_body(
      "Click <a href=\"#{frontend_url()}/reset-password?token=#{token}\" target=\"_blank\">here</a> to reset password."
    )
  end

  def password_changed(%User{email: email}) do
    base_email()
    |> to(email)
    |> subject("Reset Password")
    |> html_body("Password has been successfully reset")
  end

  defp base_email() do
    new_email()
    |> from("Bible Nota <support@biblenota.com>")
  end
end
