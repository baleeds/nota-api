defmodule Nota.Repo.Extensions do
  import Ecto.Query, warn: false

  alias Nota.Repo

  def delete_one(queryable, opts \\ []) do
    with {:ok, item} <- one(queryable),
         result when not is_nil(result) <- Repo.delete(item, opts) do
      {:ok, true}
    else
      {:error, error} -> {:error, error}
    end
  end

  def update_one(queryable, attrs, opts \\ []) do
    with {:ok, item} <- one(queryable) do
      item
      |> Ecto.Changeset.change(attrs)
      |> Repo.update(opts)
    else
      {:error, :not_found} -> {:error, :not_found}
    end
  end

  def one(queryable, opts \\ []) do
    queryable
    |> Repo.one(opts)
    |> case do
      nil -> {:error, :not_found}
      item -> {:ok, item}
    end
  end
end
