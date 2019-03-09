defmodule NotaWeb.Schema.Annotations do
  use Absinthe.Schema.Notation

  alias NotaWeb.Resolvers.Annotations.Annotation

  # # alias Absinthe.Middleware.Dataloader
  # import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :annotations_queries do
    field :annotation, non_null(:annotation) do
      arg(:id, non_null(:id))

      resolve(&Annotation.get/3)
    end

    field :annotations, list_of(non_null(:annotation)) do
      resolve(&Annotation.get_all/3)
    end
  end

  object :annotation do
    field(:id, non_null(:id))
    field(:text, non_null(:string))
    field(:verse_id, non_null(:id))
    field(:verse, non_null(:verse))
  end
end
