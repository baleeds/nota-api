defmodule Nota.Email do
  import Bamboo.Email

  alias Nota.Auth.User
  alias Nota.Auth.ResetPasswordToken

  def frontend_url do
    Application.fetch_env!(:nota, :frontend_url)
  end

  def reset_password(%User{email: email}, %ResetPasswordToken{token: token}) do
    new_email(
      to: email,
      from: "support@biblenota.com",
      subject: "Reset Password",
      html_body:
        "Click <a href=\"#{frontend_url()}/reset-password?token=#{token}\" target=\"_blank\">here</a> to reset password."
    )
  end

  def password_changed(%User{email: email}) do
    new_email(
      to: email,
      from: "support@biblenota.com",
      subject: "Password Successfully Reset",
      html_body: "Your password has recently been reset."
    )
  end
end
