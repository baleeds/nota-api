defmodule Nota.Services.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Nota.Repo
  alias Nota.Models.{User, RefreshToken}
  alias Nota.Services.Auth.Guardian

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  def get_users(), do: User

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_user_by_id(id, attrs) do
    get_user!(id)
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def upsert_user(auth) do
    with {:ok, user_or_nil} <- find_user_by_oauth(auth),
         attrs <- get_user_changes(auth) do
      case user_or_nil do
        nil -> create_user(attrs)
        user -> update_user(user, attrs)
      end
    else
      {:error, error} -> {:error, error}
    end
  end

  defp find_user_by_oauth(%{provider: oauth_provider, uid: oauth_uid}) do
    stringified_oauth_provider = Atom.to_string(oauth_provider)

    User
    |> where([u], u.oauth_provider == ^stringified_oauth_provider and u.oauth_uid == ^oauth_uid)
    |> Repo.one()
    |> case do
      user_or_nil -> {:ok, user_or_nil}
    end
  end

  defp find_user_by_oauth(_), do: {:error, "Invalid oauth information"}

  defp get_user_changes(%{
         provider: provider,
         uid: uid,
         credentials: %{
           token: token,
           refresh_token: refresh_token,
           expires: expires,
           expires_at: expires_at
         },
         info: %{
           email: email,
           first_name: first_name,
           last_name: last_name
         }
       }) do
    %{
      email: email,
      first_name: first_name,
      last_name: last_name,
      oauth_provider: Atom.to_string(provider),
      oauth_uid: uid,
      oauth_token: token,
      oauth_refresh_token: refresh_token,
      oauth_expires_at: expires_at,
      oauth_expires: expires
    }
  end

  # TODO: this is duplicate from user resolver
  # TODO: also, rename this authorization_token so it's clearer
  def get_user_authorization_token(%{id: user_id}) do
    %{
      user_id: user_id
    }
    |> Guardian.encode_and_sign()
    |> case do
      {:ok, token, claims} ->
        # TODO: perist JTI from claims on user
        {:ok, %{token: token, claims: claims}}

      _ ->
        {:error, "unable to get user authorization"}
    end
  end

  def refresh_user_authorization_token(refresh_token) do
    with true <- is_refresh_token_valid?(refresh_token),
         {:ok, _old_stuff, {access_token, %{"sub" => %{"user_id" => user_id}}}} <-
           Guardian.exchange(refresh_token, "refresh", "access", ttl: {1, :hour}) do
      IO.inspect(access_token, label: "Access")
      IO.inspect(refresh_token, label: "Refresh")
      {:ok, %{access_token: access_token, refresh_token: refresh_token, user_id: user_id}}
    else
      false -> {:error, "Invalid refresh token"}
      _ -> {:error, "Unable to refresh token"}
    end
  end

  defp is_refresh_token_valid?(refresh_token) do
    RefreshToken
    |> where([r], r.token == ^refresh_token and r.expires_at > ^DateTime.utc_now())
    |> Repo.one()
    |> case do
      nil -> false
      _ -> true
    end
  end

  def authenticate_user(email, plain_text_password) do
    User
    |> where(email: ^email)
    |> Repo.one()
    |> case do
      nil ->
        {:error, :invalid_credentials}

      user ->
        if Argon2.verify_pass(plain_text_password, user.password_hash) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  def sign_in(%User{id: user_id}) do
    resource = %{user_id: user_id}

    with {:ok, access_token, _claims} <-
           Guardian.encode_and_sign(resource, %{}, ttl: {1, :hour}),
         {:ok, %{refresh_token: %{token: refresh_token}}} <- create_refresh_token(resource) do
      {:ok,
       %{
         access_token: access_token,
         refresh_token: refresh_token,
         user_id: user_id
       }}
    else
      {:error, error} -> {:error, error}
      thing -> {:error, IO.inspect(thing)}
    end
  end

  defp create_refresh_token(resource) do
    Multi.new()
    |> Multi.run(:resource, fn _, _ -> {:ok, resource} end)
    |> Multi.delete_all(
      :deleted_tokens?,
      where(RefreshToken, [r], r.expires_at <= ^DateTime.utc_now())
    )
    |> Multi.run(:refresh_token, &generate_and_store_refresh_token/2)
    |> Repo.transaction()
  end

  defp generate_and_store_refresh_token(repo, %{resource: %{user_id: user_id} = resource}) do
    with {:ok, token, _claims} <-
           Guardian.encode_and_sign(resource, %{}, token_type: "refresh", ttl: {30, :days}) do
      expires_at = DateTime.add(DateTime.utc_now(), 30 * 60 * 60 * 24, :second)

      %RefreshToken{}
      |> RefreshToken.changeset(%{
        user_id: user_id,
        expires_at: expires_at,
        token: token
      })
      |> repo.insert()
    else
      _ -> {:error, "Could not create refresh token"}
    end
  end

  def send_forgot_password(email) do
    __MODULE__.Tx.SendForgotPassword.call(email)
    |> Repo.transaction()
    |> case do
      {:ok, _} -> {:ok, true}
      {:error, :suppress} -> {:ok, true}
      {:error, error} -> {:error, error}
      _ -> {:error, :unknown}
    end
  end

  def reset_password(token, new_password) do
    __MODULE__.Tx.ResetPassword.call(token, new_password)
    |> Repo.transaction()
    |> case do
      {:ok, _} -> {:ok, true}
      {:error, error} -> {:error, error}
      _ -> {:error, :unknown}
    end
  end

  def sign_out_everywhere(%User{id: user_id}) do
    RefreshToken
    |> where(user_id: ^user_id)
    |> Repo.delete_all()
    |> case do
      {:error, error} -> {:error, error}
      _ -> {:ok, true}
    end
  end

  def sign_out(%User{id: user_id}, refresh_token) do
    RefreshToken
    |> where(user_id: ^user_id, token: ^refresh_token)
    |> Repo.delete_all()
    |> case do
      {:error, error} -> {:error, error}
      _ -> {:ok, true}
    end
  end
end
