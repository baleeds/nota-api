defmodule Nota.Bible.VerseFavorite do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "verse_favorites" do
    belongs_to(:verse, Nota.Bible.Verse, type: :integer)
    belongs_to(:user, Nota.Auth.User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(verse_favorite, attrs) do
    verse_favorite
    |> cast(attrs, [:user_id, :verse_id])
    |> validate_required([:user_id, :verse_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:verse_id)
    |> unique_constraint([:user_id, :verse_id], message: "This verse has already bookmarked")
  end
end
