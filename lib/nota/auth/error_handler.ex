defmodule Nota.Auth.ErrorHandler do
  @moduledoc false

  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    send_resp(conn, 401, Poison.encode!(%{message: to_string(type)}))
  end
end
