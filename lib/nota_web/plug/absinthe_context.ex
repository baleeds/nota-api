defmodule NotaWeb.Plug.AbsintheContext do
  @moduledoc false

  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(%{remote_ip: remote_ip} = conn, _) do
    Guardian.Plug.current_resource(conn)
    |> case do
      nil ->
        put_private(conn, :absinthe, %{context: %{remote_ip: remote_ip, conn: conn}})

      user ->
        put_private(conn, :absinthe, %{context: %{current_user: user, conn: conn}})
    end
  end
end
