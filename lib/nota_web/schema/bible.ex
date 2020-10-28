defmodule NotaWeb.Schema.Bible do
  use Absinthe.Schema.Notation

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
  end
end
