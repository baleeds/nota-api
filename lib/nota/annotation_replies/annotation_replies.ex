defmodule Nota.AnnotationReplies do
  import Ecto.Query, warn: false

  alias Nota.Repo
  alias Nota.AnnotationReplies.AnnotationReply

  def get_annotation_replies(annotation_id) do
    AnnotationReply
    |> where(annotation_id: ^annotation_id)
  end

  def get_number_of_replies(annotation_id) do
    AnnotationReply
    |> where(annotation_id: ^annotation_id)
    |> Repo.aggregate(:count)
  end

  def save_annotation_reply(%{id: id, user_id: user_id} = attrs) do
    AnnotationReply
    |> where(id: ^id, user_id: ^user_id)
    |> Repo.Extensions.update_one(attrs)
  end

  def save_annotation_reply(attrs) do
    %AnnotationReply{}
    |> AnnotationReply.changeset(attrs)
    |> Repo.insert()
  end

  def delete_annotation_reply(id, user_id) do
    AnnotationReply
    |> where(id: ^id, user_id: ^user_id)
    |> Repo.Extensions.delete_one()
  end
end
