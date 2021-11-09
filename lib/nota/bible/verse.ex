defmodule Nota.Bible.Verse do
  use Ecto.Schema

  import Ecto.Query

  alias Nota.Annotations.Annotation
  alias Nota.Bible.VerseFavorite

  schema "verses" do
    field(:book_number, :integer)
    field(:chapter_number, :integer)
    field(:verse_number, :integer)
    field(:text, :string)

    has_many(:annotations, Annotation)
    has_many(:verse_favorites, VerseFavorite)

    field(:is_bookmarked, :boolean, virtual: true)
  end

  def include_is_bookmarked(query, nil) do
    from(a in query,
      select_merge: %{is_bookmarked: false}
    )
  end

  def include_is_bookmarked(query, user_id) do
    from(a in query,
      left_join: f in VerseFavorite,
      on: f.user_id == ^user_id and f.verse_id == a.id,
      select_merge: %{is_bookmarked: fragment("? IS NOT NULL", f.id)}
    )
  end
end
