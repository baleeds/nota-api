defmodule Nota.Annotations do
  @moduledoc """
  The Annotations context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Nota.Repo
  alias Nota.Annotations.Annotation
  alias Nota.Annotations.AnnotationFavorite
  alias Nota.Helpers.QueryHelpers

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(_queryable, %{user_id: user_id}) do
    Annotation
    |> where([a], a.user_id == ^user_id)
  end

  def query(queryable, params) do
    IO.inspect(queryable, label: "Queryable")
    IO.inspect(params, label: "Params")
    queryable
  end

  def get_my_annotations(user_id, args) do
    Annotation.projection(user_id)
    |> where([a], a.user_id == ^user_id)
    |> QueryHelpers.where_from_args(args, [:verse_id])
  end

  def get_public_annotations(args) do
    Annotation.projection()
    |> QueryHelpers.where_from_args(args, [:user_id, :verse_id])
  end

  def get_public_annotations(user_id, args) do
    Annotation.projection(user_id)
    |> where([a], a.user_id != ^user_id)
    |> QueryHelpers.where_from_args(args, [:user_id, :verse_id])
  end

  def get_annotation!(id), do: Repo.get!(Annotation.projection(), id)

  def get_annotation(id), do: Repo.get(Annotation.projection(), id)

  def create_annotation(attrs \\ %{}) do
    %Annotation{}
    |> Annotation.changeset(attrs)
    |> Repo.insert()
  end

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
    |> Multi.run(:updated_annotation, fn %{old_annotation: old_annotation} ->
      update_annotation(old_annotation, attrs)
    end)
    |> Repo.transaction()
  end

  def favorite_annotation(annotation_id, user_id) do
    %AnnotationFavorite{}
    |> AnnotationFavorite.changeset(%{annotation_id: annotation_id, user_id: user_id})
    |> Repo.insert()
  end

  def unfavorite_annotation(annotation_id, user_id) do
    AnnotationFavorite
    |> where([a], a.annotation_id == ^annotation_id and a.user_id == ^user_id)
    |> Repo.one()
    |> case do
      nil -> {:error, "Not found"}
      annotation_favorite -> delete_annotation_favorite(annotation_favorite)
    end
  end

  defp delete_annotation_favorite(%AnnotationFavorite{} = annotation_favorite) do
    Repo.delete(annotation_favorite)
  end

  defp delete_annotation_favorite(_) do
    {:error, "Unknown"}
  end

  def delete_annotation(%Annotation{} = annotation) do
    Repo.delete(annotation)
  end

  def change_annotation(%Annotation{} = annotation) do
    Annotation.changeset(annotation, %{})
  end

  # def save_annotation(%{id: id} = attrs) do
  #   get_annotation(id)
  #   |> case do
  #     nil -> create_annotation(attrs)
  #     annotation -> update_annotation(annotation, attrs)
  #   end
  # end

  # def save_annotation(attrs) do
  #   create_annotation(attrs)
  # end

  # def save_annotations(annotations, user_id) do
  #   annotations = Enum.map(annotations, &Map.put(&1, :user_id, user_id))

  #   Multi.new()
  #   |> Multi.run(:annotations, fn _ -> {:ok, annotations} end)
  #   |> Multi.run(:upserted_annotations, &upsert_annotations/1)
  #   |> Repo.transaction()
  # end

  # def upsert_annotations(%{annotations: annotations}) do
  #   annotations
  #   |> Enum.reduce_while([], fn annotation, acc -> upsert_annotation(annotation, acc) end)
  #   |> handle_upsert_annotations()
  # end

  # defp handle_upsert_annotations(annotations) when is_list(annotations), do: {:ok, annotations}
  # defp handle_upsert_annotations(other), do: {:error, other}

  # defp upsert_annotation(annotation, acc) do
  #   annotation
  #   |> save_annotation()
  #   |> handle_upsert_annotation(acc)
  # end

  # defp handle_upsert_annotation({:ok, annotation}, acc), do: {:cont, [annotation | acc]}
  # defp handle_upsert_annotation(other, _acc), do: {:halt, other}

  # # I can upsert annotations that I didn't author
  # def sync_annotations(annotations, user_id, last_synced_at) do
  #   annotations = Enum.map(annotations, &Map.put(&1, :user_id, user_id))

  #   Multi.new()
  #   |> Multi.run(:user_id, fn _ -> {:ok, user_id} end)
  #   |> Multi.run(:new_annotations, fn _ -> {:ok, annotations} end)
  #   |> Multi.run(:last_synced_at, fn _ -> {:ok, last_synced_at} end)
  #   |> Multi.run(:backend_annotations, &list_annotations_since/1)
  #   |> Multi.run(:total_changes, &get_total_changes/1)
  #   |> Multi.run(:latest_changes, &get_latest_changes/1)
  #   |> Multi.run(:affected_items, &get_affected_items/1)
  #   |> Multi.run(:upserted_annotations, &upsert_affected_annotations/1)
  #   |> Repo.transaction()
  # end

  # def list_annotations_since(%{last_synced_at: date, user_id: user_id}) do
  #   Annotation
  #   |> where([a], a.user_id == ^user_id)
  #   |> where([a], a.last_synced_at > ^date)
  #   |> Repo.all()
  #   |> case do
  #     nil -> {:error, "Error getting annotations since #{date}"}
  #     backend_annotations -> {:ok, backend_annotations}
  #   end
  # end

  # def list_annotations_since(__tx) do
  #   {:error, "Error with list_annotations_since"}
  # end

  # defp get_total_changes(%{
  #        backend_annotations: backend_annotations,
  #        new_annotations: new_annotations
  #      }) do
  #   tagged_backend_annotations = Enum.map(backend_annotations, &Map.put(&1, :source, :backend))
  #   tagged_frontend_annotations = Enum.map(new_annotations, &Map.put(&1, :source, :frontend))

  #   {:ok, tagged_backend_annotations ++ tagged_frontend_annotations}
  # end

  # # TODO: how to handle errors in piped Enum functions?  See line 240
  # defp get_latest_changes(%{total_changes: total_changes}) do
  #   total_changes
  #   |> Enum.sort(&is_item_more_recent/2)
  #   |> Enum.reverse()
  #   |> Enum.uniq_by(&Map.get(&1, :id))
  #   |> case do
  #     nil -> {:error, "Error in get_latest_changes"}
  #     latest_changes -> {:ok, latest_changes}
  #   end
  # end

  # # defp get_latest_changes(%{total_changes: total_changes}) do
  # #   with {:ok, sorted_list} <- is_item_more_recent(total_changes),
  # #         reversed_list <- Enum.reverse(sorted_list),
  # #         uniqued_list <- Enum.uniq_by(&Map.get(&1, :id)) do
  # #           uniqued_list
  # #         end
  # #   else
  # #   {:error, :updated_at} -> {:error, "inserted at not provided"}
  # #   {:error, reason} -> {:error, reason}
  # #   end
  # # end

  # defp get_latest_changes(arg),
  #   do: {:error, "Failed to pattern match on get_latest_changes: #{arg}"}

  # defp date_sorter(date1, date2) do
  #   result = Date.compare(date1, date2)

  #   case result do
  #     r when r == :lt or r == :eq -> true
  #     _ -> false
  #   end
  # end

  # defp is_item_more_recent(%{updated_at: a_updated_at}, %{updated_at: b_updated_at}),
  #   do: date_sorter(a_updated_at, b_updated_at)

  # defp is_item_more_recent(_, _), do: {:error, "updated_at not provided"}

  # defp get_affected_items(%{latest_changes: latest_changes}) do
  #   latest_changes
  #   |> Enum.reduce(
  #     %{affected_backend_annotations: [], affected_frontend_annotations: []},
  #     &split_changes/2
  #   )
  #   |> case do
  #     nil -> {:error, "Error in get_affected_items"}
  #     affected_items -> {:ok, affected_items}
  #   end
  # end

  # defp split_changes(
  #        %{source: :frontend} = item,
  #        %{affected_frontend_annotations: affected_frontend_annotations} = acc
  #      ),
  #      do: Map.put(acc, :affected_frontend_annotations, [item | affected_frontend_annotations])

  # defp split_changes(item, %{affected_backend_annotations: affected_backend_annotations} = acc),
  #   do: Map.put(acc, :affected_backend_annotations, [item | affected_backend_annotations])

  # defp prep_annotations_for_upsert(annotation) do
  #   annotation
  #   |> Map.put(:last_synced_at, DateTime.utc_now())
  #   |> Map.drop([:source])
  #   |> IO.inspect()
  # end

  # defp upsert_affected_annotations(%{
  #        affected_items: %{affected_frontend_annotations: affected_frontend_annotations}
  #      }) do
  #   pruned_annotations = Enum.map(affected_frontend_annotations, &prep_annotations_for_upsert/1)

  #   upsert_annotations(%{annotations: pruned_annotations})
  # end
end
