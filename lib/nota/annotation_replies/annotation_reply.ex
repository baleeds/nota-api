defmodule Nota.AnnotationReplies.AnnotationReply do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "annotation_replies" do
    field(:text, :string)

    belongs_to(:user, Nota.Auth.User)
    belongs_to(:annotation, Nota.Annotations.Annotation)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(annotation_reply, attrs) do
    annotation_reply
    |> cast(attrs, [:annotation_id, :user_id, :text])
    |> validate_required(:text)
    |> validate_length(:text, max: 1000, message: "Reply is too long")
  end
end
