defmodule NotaWeb.Schema.Bible do
  import AbsintheErrorPayload.Payload

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias NotaWeb.Resolvers.Bible

  object :bible_queries do
    field :verse, non_null(:verse) do
      arg(:id, non_null(:id))

      resolve(&Bible.get_verse/3)
    end

    field :verses, list_of(non_null(:verse)) do
      arg(:book_number, non_null(:integer))
      arg(:chapter_number, non_null(:integer))

      resolve(&Bible.get_verses_by/3)
    end
  end

  object :verse do
    field(:id, non_null(:id))
    field(:book_number, non_null(:integer))
    field(:chapter_number, non_null(:integer))
    field(:verse_number, non_null(:integer))
    field(:text, non_null(:string))
    field(:is_bookmarked, non_null(:boolean))
    field(:is_annotated, non_null(:boolean))
    field(:is_annotated_by_me, non_null(:boolean))
  end

  input_object :bookmark_verse_input do
    field(:verse_id, non_null(:id))
  end

  input_object :unbookmark_verse_input do
    field(:verse_id, non_null(:id))
  end

  payload_object(:bookmark_verse_payload, :verse)

  payload_object(:unbookmark_verse_payload, :verse)

  object :bible_mutations do
    field :bookmark_verse, non_null(:bookmark_verse_payload) do
      arg(:input, non_null(:bookmark_verse_input))

      resolve(&Bible.bookmark_verse/3)
    end

    field :unbookmark_verse, non_null(:unbookmark_verse_payload) do
      arg(:input, non_null(:unbookmark_verse_input))

      resolve(&Bible.unbookmark_verse/3)
    end
  end
end
