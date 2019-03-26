defmodule Nota.Annotations do
  @moduledoc """
  The Annotations context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi

  alias Nota.Repo

  alias Nota.Annotations.Annotation

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end

  @doc """
  Returns the list of annotation.

  ## Examples

      iex> list_annotation()
      [%Annotation{}, ...]

  """
  def list_annotations do
    Repo.all(Annotation)
  end

  def list_annotations(%{user_id: user_id}) do
    Annotation
    |> where([a], a.user_id == ^user_id)
    |> Repo.all
  end

  @doc """
  Gets a single annotation.

  Raises `Ecto.NoResultsError` if the Annotation does not exist.

  ## Examples

      iex> get_annotation!(123)
      %Annotation{}

      iex> get_annotation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_annotation!(id), do: Repo.get!(Annotation, id)

  def get_annotation(id), do: Repo.get(Annotation, id)

  @doc """
  Creates a annotation.

  ## Examples

      iex> create_annotation(%{field: value})
      {:ok, %Annotation{}}

      iex> create_annotation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_annotation(attrs \\ %{}) do
    %Annotation{}
    |> Annotation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a annotation.

  ## Examples

      iex> update_annotation(annotation, %{field: new_value})
      {:ok, %Annotation{}}

      iex> update_annotation(annotation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_annotation(%Annotation{} = annotation, attrs) do
    annotation
    |> Annotation.changeset(attrs)
    |> Repo.update()
  end

  def update_annotation(%{id: id} = attrs) do
    Multi.new()
    |> Multi.run(:annotation_id, fn _ -> {:ok, id} end)
    |> Multi.run(:old_annotation, fn _ -> 
      case get_annotation!(id) do
        nil -> {:error, %{key: :annotation, message: "not found"}}
        annotation -> {:ok, annotation}
      end
    end)
    |> Multi.run(:updated_annotation, fn %{old_annotation: old_annotation} -> update_annotation(old_annotation, attrs) end)
    |> Repo.transaction()
  end

  @doc """
  Deletes a Annotation.

  ## Examples

      iex> delete_annotation(annotation)
      {:ok, %Annotation{}}

      iex> delete_annotation(annotation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_annotation(%Annotation{} = annotation) do
    Repo.delete(annotation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking annotation changes.

  ## Examples

      iex> change_annotation(annotation)
      %Ecto.Changeset{source: %Annotation{}}

  """
  def change_annotation(%Annotation{} = annotation) do
    Annotation.changeset(annotation, %{})
  end

  def save_annotation(%{id: id} = attrs) do
    get_annotation(id)
    |> case do
      nil -> create_annotation(attrs)
      annotation -> update_annotation(annotation, attrs)
    end
  end

  def save_annotation(attrs) do
    create_annotation(attrs)
  end
end
