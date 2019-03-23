defmodule NotaWeb.Plug.PrivatePipeline do
  @moduledoc false

  use Guardian.Plug.Pipeline,
    otp_app: :nota,
    module: Nota.Auth.Guardian,
    error_handler: Nota.Auth.ErrorHandler

  plug(Guardian.Plug.VerifyHeader, [%{"typ" => "access"}])
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
