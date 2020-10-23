defmodule NotaWeb.Resolvers.Annotations.Favorite do
  alias Nota.Annotations

  def favorite_annotation(_, %{annotation_id: annotation_id}, %{
        context: %{current_user: %{id: user_id}}
      }) do
    Annotations.favorite_annotation(annotation_id, user_id)
    |> case do
      {:ok, _favorite_annotation} -> {:ok, %{success: true}}
      {:error, error} -> {:error, error}
    end
  end

  def favorite_annotation(_, _, _) do
    {:error, "You must be logged in to favorite an annotation"}
  end

  def unfavorite_annotation(_, %{annotation_id: annotation_id}, %{
        context: %{current_user: %{id: user_id}}
      }) do
    Annotations.unfavorite_annotation(annotation_id, user_id)
    |> case do
      {:ok, _unfavorite_annotation} -> {:ok, %{success: true}}
      {:error, error} -> {:error, error}
    end
  end

  def unfavorite_annotation(_, _, _) do
    {:error, "You must be logged in to unfavorite an annotation"}
  end
end
