defmodule Nota.Models.Verse do
  use Ecto.Schema

  import Ecto.Query

  schema "verses" do
    field(:book_number, :integer)
    field(:chapter_number, :integer)
    field(:verse_number, :integer)
    field(:text, :string)

    has_many(:annotations, Nota.Models.Annotation)
    has_many(:verse_favorites, Nota.Models.VerseFavorite)

    field(:is_bookmarked, :boolean, virtual: true)
    field(:is_annotated, :boolean, virtual: true)
    field(:is_annotated_by_me, :boolean, virtual: true)
  end

  def include_is_bookmarked(query, nil) do
    from(a in query,
      select_merge: %{is_bookmarked: false}
    )
  end

  def include_is_bookmarked(query, user_id) do
    from(a in query,
      left_join: f in Nota.Models.VerseFavorite,
      on: f.user_id == ^user_id and f.verse_id == a.id,
      select_merge: %{is_bookmarked: fragment("? IS NOT NULL", f.id)}
    )
  end

  def include_is_annotated(query, user_id) do
    from(v in query,
      distinct: v.id,
      left_join: a in Nota.Models.Annotation,
      on: a.verse_id == v.id,
      select_merge: %{is_annotated: fragment("? IS NOT NULL", a.id)}
    )
    |> include_is_annotated_by_me(user_id)
  end

  defp include_is_annotated_by_me(query, nil) do
    from(v in query, select_merge: %{is_annotated_by_me: false})
  end

  defp include_is_annotated_by_me(query, user_id) do
    from(v in query,
      left_join: ma in Nota.Models.Annotation,
      on: ma.verse_id == v.id and ma.user_id == ^user_id,
      select_merge: %{is_annotated_by_me: fragment("? IS NOT NULL", ma.id)}
    )
  end
end
