defmodule NotaWeb.Schema.Bible do
  use Absinthe.Schema.Notation

  alias Nota.Bible
  alias Nota.Annotations

  alias NotaWeb.Resolvers.Bible.Verse

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :bible_queries do
    field :verse, non_null(:verse) do
      arg(:id, non_null(:id))

      resolve(&Verse.get/3)
    end

    field :verses, list_of(non_null(:verse)) do
      arg(:book_number, non_null(:integer))
      arg(:chapter_number, non_null(:integer))
      
      resolve(&Verse.get_by/3)
    end
  end

  object :verse do
    field(:id, non_null(:id))
    field(:book_number, non_null(:integer))
    field(:chapter_number, non_null(:integer))
    field(:verse_number, non_null(:integer))
    field(:text, non_null(:string))
    
    field(:annotations, list_of(non_null(:annotation)), resolve: dataloader(Annotations.Annotation))
  end
end
