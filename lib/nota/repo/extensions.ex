defmodule Nota.Repo.Extensions do
  import Ecto.Query, warn: false

  alias Nota.Repo

  def delete_one(queryable, opts \\ []) do
    with {:ok, annotation} <- one(queryable),
         result when not is_nil(result) <- Repo.delete(annotation) do
      {:ok, true}
    else
      {:error, error} -> {:error, error}
      _ -> {:error, "Could not delete"}
    end
  end

  def one(queryable, opts \\ []) do
    queryable
    |> Repo.one()
    |> case do
      nil -> {:error, "Not found"}
      item -> {:ok, item}
    end
  end
end
