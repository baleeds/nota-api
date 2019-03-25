defmodule NotaWeb.Plug.AbsintheContext do
  @moduledoc false

  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    case Guardian.Plug.current_resource(conn) |> IO.inspect do
      user ->
        put_private(conn, :absinthe, %{context: %{current_user: user}})
    end
  end
end
