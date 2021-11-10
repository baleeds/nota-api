defmodule NotaWeb.Plug.PrivatePipeline do
  @moduledoc false

  use Guardian.Plug.Pipeline,
    otp_app: :nota,
    module: Nota.Services.Auth.Guardian,
    error_handler: Nota.Services.Auth.ErrorHandler

  plug(Guardian.Plug.VerifyHeader, [%{"typ" => "access"}])
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
