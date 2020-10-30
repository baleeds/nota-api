defmodule Nota.Annotations.AnnotationFavorite do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "annotation_favorites" do
    belongs_to(:annotation, Nota.Annotations.Annotation)
    belongs_to(:user, Nota.Auth.User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(annotation_favorite, attrs) do
    annotation_favorite
    |> cast(attrs, [:annotation_id, :user_id])
    |> validate_required([:annotation_id, :user_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:annotation_id)
    |> unique_constraint([:user_id, :annotation_id], message: "already been favorited")
  end
end
