defmodule Nota.Annotations.Annotation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nota.Bible.Verse

  @required_fields ~w(
    verse_id
    text
  )a

  @optional_fields ~w()a

  @all_fields @required_fields ++ @optional_fields

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "annotation" do
    field :text, :string

    belongs_to :verse, Verse, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(annotation, attrs) do
    annotation
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:verse_id)
  end
end
