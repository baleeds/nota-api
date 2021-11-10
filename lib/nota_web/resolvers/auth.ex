defmodule NotaWeb.Resolvers.Auth do
  alias Nota.Services.Auth

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

  def send_forgot_password(_, %{input: %{email: email}}, _) do
    Auth.send_forgot_password(email)
    |> case do
      {:ok, _} -> {:ok, true}
      {:error, error} -> {:error, error}
    end
  end

  def reset_password(_, %{input: %{token: token, password: password}}, _) do
    Auth.reset_password(token, password)
  end

  def sign_out_everywhere(_, _, %{context: %{current_user: current_user}}) do
    Auth.sign_out_everywhere(current_user)
  end

  def sign_out(_, %{refresh_token: refresh_token}, %{context: %{current_user: current_user}}) do
    Auth.sign_out(current_user, refresh_token)
  end

  def get_user_for_session(%{user_id: user_id}, _, _) do
    Auth.get_user(user_id)
    |> case do
      nil -> {:error, "Could not load user"}
      user -> {:ok, user}
    end
  end

  def get_user_for_session(_, _, _) do
    {:error, :unknown}
  end

  def change_display_name(_, %{input: %{first_name: first_name, last_name: last_name}}, %{
        context: %{current_user: %{id: user_id}}
      }) do
    Auth.update_user_by_id(user_id, %{first_name: first_name, last_name: last_name})
    |> case do
      {:ok, user} -> {:ok, user}
      {:error, error} -> {:error, error}
    end
  end

  def change_display_name(_, _, _) do
    {:error, :unknown}
  end

  def change_password(_, %{input: %{old_password: old_password, new_password: new_password}}, %{
        context: %{current_user: %{id: user_id}}
      }) do
    Auth.change_password(user_id, old_password, new_password)
    |> case do
      {:ok, _user} -> {:ok, true}
      {:error, error} -> {:error, error}
    end
  end

  def change_password(_, _, _) do
    {:error, :unknown}
  end
end
