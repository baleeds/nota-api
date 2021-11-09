defmodule NotaWeb.Plug.AbsintheContext do
  @moduledoc false

  @behaviour Plug

  import Absinthe.Plug

  def init(opts), do: opts

  def call(conn, _) do
    put_options(conn, %{context: build_context(conn)})
  end

  defp build_context(conn) do
    %{conn: conn}
    |> add_user()
    |> add_user_id()
  end

  # Add the current_user key for a user if one exists.
  defp add_user(%{conn: conn} = context) do
    Guardian.Plug.current_resource(conn)
    |> case do
      nil -> context
      user -> Map.merge(context, %{current_user: user})
    end
  end

  # Add the current_user_id key and set to user ID or nil.
  defp add_user_id(%{current_user: %{id: id}} = context) do
    Map.merge(context, %{current_user_id: id})
  end

  defp add_user_id(context) do
    Map.merge(context, %{current_user_id: nil})
  end
end
