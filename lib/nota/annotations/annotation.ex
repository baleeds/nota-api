defmodule Nota.Annotations.Annotation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nota.Bible.Verse
  alias Nota.Auth.User

  @required_fields ~w(
    verse_id
    user_id
    text
  )a

  @optional_fields ~w(
    id
    inserted_at
    deleted_at
  )a

  @all_fields @required_fields ++ @optional_fields

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "annotations" do
    field :text, :string
    field :deleted_at, :utc_datetime

    belongs_to :verse, Verse, type: :integer
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(annotation, attrs) do
    annotation
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:verse_id)
    |> foreign_key_constraint(:user_id)
  end
end
