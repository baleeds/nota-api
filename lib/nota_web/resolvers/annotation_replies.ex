defmodule NotaWeb.Resolvers.AnnotationReplies do
  alias Nota.AnnotationReplies
  alias Nota.Repo
  alias Absinthe.Relay.Connection

  def get_annotation_replies(_, %{annotation_id: annotation_id} = args, _) do
    AnnotationReplies.get_annotation_replies(annotation_id)
    |> Connection.from_query(&Repo.all/1, args)
  end

  def get_annotation_replies(_, _, _) do
    {:error, :unknown}
  end

  def save_annotation_reply(_, %{input: attrs}, %{context: %{current_user: %{id: user_id}}}) do
    attrs
    |> Map.put(:user_id, user_id)
    |> AnnotationReplies.save_annotation_reply()
  end

  def save_annotation_reply(_, _, _) do
    {:error, :unknown}
  end

  def delete_annotation_reply(_, %{id: id}, %{context: %{current_user: %{id: user_id}}}) do
    AnnotationReplies.delete_annotation_reply(id, user_id)
  end

  def delete_annotation_reply(_, _, _) do
    {:error, :unknown}
  end
end
