defmodule NotaWeb.Plug.AbsintheContext do
  @moduledoc false

  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(%{remote_ip: remote_ip} = conn, _) do
    IO.inspect(conn)
    case Guardian.Plug.current_resource(conn) do
      nil ->
        put_private(conn, :absinthe, %{context: %{remote_ip: remote_ip}})
        
      user ->
        put_private(conn, :absinthe, %{context: %{current_user: user}})
    end
  end
end
