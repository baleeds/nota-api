defmodule Nota.Repo.Extensions do
  import Ecto.Query, warn: false

  alias Nota.Repo

  @doc """
  Delete one record using a queryable to select the item.  This facilirates enforcing that certain fields
  match, other than simply ID.

  Returns {:error, :not_found} if the item doesn't exist.  Otherwise, returns true if the record was deleted,
  or a changeset in the event of a failure.
  """
  def delete_one(queryable, repo_delete_opts \\ []) do
    with {:ok, item} <- one(queryable) do
      case Repo.delete(item, repo_delete_opts) do
        {:ok, _deleted_item} -> {:ok, true}
        {:error, error} -> {:error, error}
      end
    else
      {:error, _} -> {:error, :not_found}
    end
  end

  @doc """
  Update one record using a queryable to select the item.  This facilitates enforcing that certain fields
  match, other than simply ID.

  Returns {:error, :not_found} if the item doesn't exist.  Otherwise, returns the updated record, or a
  changeset in the event of validation failure.
  """
  def update_one(queryable, changeset_fn, attrs, repo_update_opts \\ [])
      when is_function(changeset_fn) and is_map(attrs) do
    with {:ok, item} <- one(queryable) do
      item
      |> changeset_fn.(attrs)
      |> Repo.update(repo_update_opts)
    else
      {:error, :not_found} -> {:error, :not_found}
    end
  end

  # def upsert_one(queryable, %{id: id} = attrs) do
  #   case Repo.one(queryable) do
  #     nil ->
  #       nil
  #   end
  # end

  @doc """
  Query one result from a queryable.

  Returns {:error, :not_found} if the result is nil.  Otherwise {:ok, returned_item}.
  """
  def one(queryable, repo_one_opts \\ []) do
    queryable
    |> Repo.one(repo_one_opts)
    |> case do
      nil -> {:error, :not_found}
      item -> {:ok, item}
    end
  end
end
