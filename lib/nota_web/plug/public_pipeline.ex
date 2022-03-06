defmodule NotaWeb.Plug.PublicPipeline do
  @moduledoc false

  use Guardian.Plug.Pipeline,
    otp_app: :nota,
    module: Nota.Services.Auth.Guardian,
    error_handler: Nota.Services.Auth.ErrorHandler

  plug(Guardian.Plug.VerifyHeader, claims: %{typ: "access"})
  # if there isn't anyone logged in we don't want to return an error
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
