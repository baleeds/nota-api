defmodule NotaWeb.Resolvers.Annotations do
  alias Nota.Annotations
  alias Nota.AnnotationReplies
  alias Nota.Repo
  alias Absinthe.Relay.Connection

  def get(_, %{id: id}, %{context: %{current_user: %{id: user_id}}}) do
    Annotations.get_annotation(id, user_id)
  end

  def get(_, %{id: id}, _) do
    Annotations.get_annotation(id, nil)
  end

  def get_my_annotations(_, args, %{context: %{current_user: %{id: user_id}}}) do
    Annotations.get_my_annotations(user_id, args)
    |> Connection.from_query(&Repo.all/1, args)
  end

  def get_my_annotations(_, _, _) do
    {:error, "You must be logged in to view your annotations"}
  end

  def get_public_annotations(_, args, %{context: %{current_user: %{id: user_id}}}) do
    Annotations.get_public_annotations(user_id, args)
    |> Connection.from_query(&Repo.all/1, args)
  end

  def get_public_annotations(_, args, _) do
    Annotations.get_public_annotations(args)
    |> Connection.from_query(&Repo.all/1, args)
  end

  def get_number_of_replies(%{id: annotation_id}, _, _) do
    AnnotationReplies.get_number_of_replies(annotation_id)
    |> case do
      number when is_integer(number) -> {:ok, number}
      {:error, error} -> {:error, error}
    end
  end

  def get_number_of_replies(_, _, _), do: {:error, :unknown}

  def get_number_of_favorites(%{id: annotation_id}, _, _) do
    Annotations.get_number_of_favorites(annotation_id)
    |> case do
      number when is_integer(number) -> {:ok, number}
      {:error, error} -> {:error, error}
    end
  end

  def get_number_of_favorites(_, _, _), do: {:error, :unknown}

  def save(_, %{input: input}, %{context: %{current_user: %{id: user_id}}}) do
    input
    |> Map.put(:user_id, user_id)
    |> Annotations.save_annotation()
    |> case do
      {:ok, annotation} -> {:ok, annotation}
      e -> e
    end
  end

  def save(_, _, _), do: {:error, "Unauthorized"}

  def delete_annotation(_, %{annotation_id: annotation_id}, %{
        context: %{current_user: %{id: user_id}}
      }) do
    Annotations.delete_annotation(annotation_id, user_id)
  end

  def delete_annotation(_, _, _) do
    {:error, "You must be logged in to delete your annotation"}
  end

  def favorite_annotation(_, %{input: %{annotation_id: annotation_id}}, %{
        context: %{current_user: %{id: user_id}}
      }) do
    Annotations.favorite_annotation(annotation_id, user_id)
    # |> IO.puts()
    |> case do
      {:ok, _favorite_annotation} -> {:ok, true}
      {:error, error} -> {:error, error}
    end
  end

  def favorite_annotation(_, _, _) do
    {:error, "You must be logged in to favorite an annotation"}
  end

  def unfavorite_annotation(_, %{input: %{annotation_id: annotation_id}}, %{
        context: %{current_user: %{id: user_id}}
      }) do
    Annotations.unfavorite_annotation(annotation_id, user_id)
    |> case do
      {:ok, _unfavorite_annotation} -> {:ok, true}
      {:error, error} -> {:error, error}
    end
  end

  def unfavorite_annotation(_, _, _) do
    {:error, "You must be logged in to unfavorite an annotation"}
  end

  def get_favorite_annotations(_, %{user_id: user_id} = args, _) do
    Annotations.get_favorite_annotations(user_id)
    |> Connection.from_query(&Repo.all/1, args)
  end

  def get_favorite_annotations(_, args, %{context: %{current_user: %{id: user_id}}}) do
    Annotations.get_favorite_annotations(user_id)
    |> Connection.from_query(&Repo.all/1, args)
  end

  # def save_all(_, %{input: input}, %{context: %{current_user: %{id: user_id}}}) do
  #   input
  #   |> Annotations.save_annotations(user_id)
  #   |> case do
  #     {:ok, %{upserted_annotations: annotations}} -> {:ok, %{annotations: annotations}}
  #     e -> e
  #   end
  # end

  # def save_all(_, _, _), do: {:error, "Unauthorized"}

  # def sync(_, %{input: %{last_synced_at: last_synced_at, annotations: annotations}}, %{
  #       context: %{current_user: %{id: user_id}}
  #     }) do
  #   Annotations.sync_annotations(annotations, user_id, last_synced_at)
  #   |> IO.inspect()
  #   |> handle_sync
  # end

  # def sync(_, _, _), do: {:error, "Unauthorized"}

  # defp handle_sync(
  #        {:ok,
  #         %{
  #           affected_items: %{affected_backend_annotations: new_annotations},
  #           upserted_annotations: upserted_annotations
  #         }}
  #      ) do
  #   {:ok, %{annotations: new_annotations, upserted_annotations: upserted_annotations}}
  # end

  # defp handle_sync(_other), do: {:error, "Error saving annotations"}

  # def sync(_, args, %{context: %{current_user: %{id: user_id}}}) do
  #   IO.inspect(args)
  #   {:ok, "nothin"}
  # end

  # defp transform_errors(changeset) do
  #   changeset
  #   |> Ecto.Changeset.traverse_errors(&format_error/1)
  #   |> Enum.map(fn
  #     {key, value} ->
  #       %{key: key, message: value}
  #   end)
  # end

  # @spec format_error(Ecto.Changeset.error()) :: String.t()
  # defp format_error({msg, opts}) do
  #   Enum.reduce(opts, msg, fn {key, value}, acc ->
  #     String.replace(acc, "%{#{key}}", to_string(value))
  #   end)
  # end
end
