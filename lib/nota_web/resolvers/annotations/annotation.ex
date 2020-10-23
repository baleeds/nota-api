defmodule NotaWeb.Resolvers.Annotations.Annotation do
  alias Nota.Annotations
  alias Nota.Repo
  alias Absinthe.Relay.Connection

  def get(_, %{id: id}, _) do
    Annotations.get_annotation!(id)
    |> case do
      nil -> {:error, "Error retrieving annotation"}
      annotation -> {:ok, annotation}
    end
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

  def save(_, %{input: input}, %{context: %{current_user: %{id: user_id}}}) do
    input
    |> Map.put(:user_id, user_id)
    |> Annotations.save_annotation()
    |> case do
      {:ok, annotation} -> {:ok, %{annotation: annotation}}
      e -> e
    end
  end

  def save(_, _, _), do: {:error, "Unauthorized"}

  def save_all(_, %{input: input}, %{context: %{current_user: %{id: user_id}}}) do
    input
    |> Annotations.save_annotations(user_id)
    |> case do
      {:ok, %{upserted_annotations: annotations}} -> {:ok, %{annotations: annotations}}
      e -> e
    end
  end

  def save_all(_, _, _), do: {:error, "Unauthorized"}

  def sync(_, %{input: %{last_synced_at: last_synced_at, annotations: annotations}}, %{
        context: %{current_user: %{id: user_id}}
      }) do
    Annotations.sync_annotations(annotations, user_id, last_synced_at)
    |> IO.inspect()
    |> handle_sync
  end

  def sync(_, _, _), do: {:error, "Unauthorized"}

  defp handle_sync(
         {:ok,
          %{
            affected_items: %{affected_backend_annotations: new_annotations},
            upserted_annotations: upserted_annotations
          }}
       ) do
    {:ok, %{annotations: new_annotations, upserted_annotations: upserted_annotations}}
  end

  defp handle_sync(_other), do: {:error, "Error saving annotations"}

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
