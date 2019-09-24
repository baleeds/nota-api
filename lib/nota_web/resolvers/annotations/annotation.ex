defmodule NotaWeb.Resolvers.Annotations.Annotation do
  alias Nota.Annotations

  def get(_, %{id: id}, _) do
    Annotations.get_annotation!(id)
    |> case do
      nil -> {:error, "Error retrieving annotation"}
      annotation -> {:ok, annotation}
    end
  end

  def get_all(_, %{user_id: _user_id} = args, _) do
    Annotations.list_annotations(args)
    |> case do
      nil -> {:error, "Error retrieving annotations"}
      annotations -> {:ok, annotations}
    end
  end

  def get_all(_, %{verse_id: _verse_id} = args, _) do
    Annotations.list_annotations(args)
    |> case do
      nil -> {:error, "Error retreiving annotations"}
      annotations -> {:ok, annotations}
    end
  end

  def get_all(_, _, _) do
    Annotations.list_annotations()
    |> case do
      nil -> {:error, "Error retrieving annotations"}
      annotations -> {:ok, annotations}
    end
  end

  def get_public(_, %{verse_id: verse_id}, %{context: %{current_user: %{id: user_id}}}) do
    Annotations.list_public_annotations(verse_id, user_id)
    |> case do
      nil -> {:error, "Error retrieving annotations"}
      annotations -> {:ok, annotations}
    end
  end

  def get_public(_, %{verse_id: _verse_id} = args, _) do
    Annotations.list_annotations(args)
    |> case do
      nil -> {:error, "Error retrieving annotations"}
      annotations -> {:ok, annotations}
    end
  end

  def get_public(_, _, _), do: {:error, "Unauthorized"}

  def get_since(_, %{date: date}, %{context: %{current_user: %{id: user_id}}}) do
    %{last_synced_at: date, user_id: user_id}
    |> Annotations.list_annotations_since()
    |> case do
      nil -> {:error, "Error retrieving annotations"}
      annotations -> {:ok, annotations}
    end
  end

  def get_since(_, _, _), do: {:error, "Unauthorized"}

  def inspect_user(%{context: %{ current_user: user } }) do
    IO.inspect(user, label: "contextual user")
  end

  def inspect_user(_) do
    IO.inspect("NO USER")
  end

  def save(_, %{input: input}, %{context: %{ current_user: %{id: user_id} }}) do
    input
    |> Map.put(:user_id, user_id)
    |> Annotations.save_annotation()
    |> case do
      {:ok, annotation} -> {:ok, %{annotation: annotation}}
      e -> e
    end
  end

  def save(_, _, _), do: {:error, "Unauthorized"}

  def save_all(_, %{input: input}, %{context: %{ current_user: %{ id: user_id } }}) do
    input
    |> Annotations.save_annotations(user_id)
    |> case do
      {:ok, %{upserted_annotations: annotations}} -> {:ok, %{annotations: annotations}}
      e -> e
    end
  end

  def save_all(_, _, _), do: {:error, "Unauthorized"}

  def sync(_, %{input: %{last_synced_at: last_synced_at, annotations: annotations}}, %{context: %{current_user: %{id: user_id}}}) do
    Annotations.sync_annotations(annotations, user_id, last_synced_at)
    |> IO.inspect
    |> handle_sync
  end

  def sync(_, _, _), do: {:error, "Unauthorizard"}

  defp handle_sync({:ok, %{affected_items: %{affected_backend_annotations: new_annotations}, upserted_annotations: upserted_annotations}}) do
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