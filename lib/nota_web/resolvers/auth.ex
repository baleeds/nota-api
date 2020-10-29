defmodule NotaWeb.Resolvers.Auth do
  alias Nota.Auth

  def get_users(_, _, _) do
    Auth.get_users()
  end

  def get_user(_, %{id: id}, _) do
    Auth.get_user(id)
    |> case do
      nil -> {:error, "Error retrieving user"}
      user -> {:ok, user}
    end
  end

  def refresh_token(_, %{refresh_token: token}, _) do
    Auth.refresh_user_authorization_token(token)
  end

  def refresh_token(_, _, _) do
    {:error, :unknown}
  end

  def get_me(_, _, %{context: %{current_user: %{id: user_id}}}) do
    Auth.get_user(user_id)
    |> case do
      nil -> {:error, "Error retrieving user"}
      user -> {:ok, user}
    end
  end

  def get_me(_, _, _), do: {:error, :unknown}

  def create_account(_, _, %{context: %{current_user: %{id: _user_id}}}) do
    {:error, "Please log out before creating a new account"}
  end

  def create_account(_, %{input: input}, _) do
    Auth.create_user(input)
  end

  def sign_in(_, _, %{context: %{current_user: %{id: _user_id}}}) do
    {:error, "Please log out before signing in again"}
  end

  def sign_in(_, %{input: %{email: email, password: password}}, _) do
    with {:ok, user} <- Auth.authenticate_user(email, password) do
      Auth.sign_in(user)
    else
      {:error, error} -> {:error, error}
    end
  end
end
