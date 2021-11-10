defmodule Nota.Models.AnnotationReply do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nota.Models.{Annotation, User}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "annotation_replies" do
    field(:text, :string)

    belongs_to(:user, User)
    belongs_to(:annotation, Annotation)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(annotation_reply, attrs) do
    annotation_reply
    |> cast(attrs, [:annotation_id, :user_id, :text])
    |> validate_required(:text)
    |> validate_length(:text, max: 1000, message: "Reply is too long")
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:annotation_id)
  end
end
