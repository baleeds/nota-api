defmodule NotaWeb.Resolvers.Auth.User do
  alias Nota.Auth

  def get_all(_, _, _) do
    Auth.get_users()
    |> case do
      nil -> {:error, "Error retrieving users"}
      users -> {:ok, users}
    end
  end

  def get(_, %{id: id}, _) do
    Auth.get_user(id)
    |> case do
      nil -> {:error, "Error retrieving user"}
      user -> {:ok, user}
    end
  end
end