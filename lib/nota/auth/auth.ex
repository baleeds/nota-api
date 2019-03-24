defmodule Nota.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Nota.Repo
  alias Nota.Auth.User

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

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

  def upsert_user(auth) do
    IO.inspect(auth)
    Multi.new()
    |> Multi.run(:auth, fn _ -> {:ok, auth} end)
    |> Multi.run(:existing_user, &find_user_by_oauth/1)
    |> Multi.run(:user, &upsert_oauth_user/1)
    |> Repo.transaction()
    |> IO.inspect()
    |> case do
      {:ok, %{user: user}} ->
        {:ok, user}

      {:error, _error_atom, reason, _} when is_binary(reason) ->
        {:error, reason}

      {:error, _error_atom, error_changeset, _} ->
        {:error, error_changeset}
    end
  end

  defp find_user_by_oauth(%{auth: %{provider: oauth_provider, uid: oauth_uid} }) do
    stringified_oauth_provider = Atom.to_string(oauth_provider)
    User
    |> where([u], u.oauth_provider == ^stringified_oauth_provider and u.oauth_uid == ^oauth_uid)
    |> Repo.one()
    |> IO.inspect()
    |> case do
      user -> {:ok, user}
    end
  end

  defp find_user_by_oauth(_) do
    {:error, "Not sure whats happening"}
  end

  defp upsert_oauth_user(%{existing_user: nil} = changes) do
    %User{}
    |> User.changeset(get_user_changes(changes))
    |> Repo.insert()
  
    # changes
    # |> IO.inspect()
    # |> get_user_changes()
    # |> User.changeset()
    # |> Repo.insert()
  end

  defp upsert_oauth_user(%{existing_user: existing_user} = changes) do
    existing_user
    |> User.changeset(get_user_changes(changes))
    |> Repo.update()
  end

  defp get_user_changes(%{
    auth: %{
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
    },
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
      oauth_expires: expires,
    }
  end

  defp get_user_changes(_) do
    {:error, "Changes are invalid"}
  end
end
