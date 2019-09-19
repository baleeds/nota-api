defmodule NotaWeb.Schema.Annotations do
  use Absinthe.Schema.Notation

  alias Nota.Bible
  alias Nota.Auth

  alias NotaWeb.Resolvers.Annotations.Annotation

  # # alias Absinthe.Middleware.Dataloader
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :annotations_queries do
    field :annotation, non_null(:annotation) do
      arg(:id, non_null(:id))

      resolve(&Annotation.get/3)
    end

    field :annotations, list_of(non_null(:annotation)) do
      arg(:user_id, :id)
    
      resolve(&Annotation.get_all/3)
    end

    field :verse_annotations, list_of(non_null(:annotation)) do
      arg(:verse_id, :id)

      resolve(&Annotation.get_all/3)
    end

    field :annotations_since, list_of(non_null(:annotation)) do
      arg(:date, :datetime)

      resolve(&Annotation.get_since/3)
    end
  end

  object :annotations_mutations do
    field :save_annotation, non_null(:save_annotation_payload) do
      arg(:input, non_null(:save_annotation_input))

      resolve(&Annotation.save/3)
    end

    field :save_annotations, non_null(:save_annotations_paylaod) do
      arg(:input, non_null(list_of(non_null(:save_annotation_input))))

      resolve(&Annotation.save_all/3)
    end

    field :sync_annotations, non_null(:sync_annotations_payload) do
      arg(:input, non_null(:sync_annotations_input))

      resolve(&Annotation.sync/3)
    end
  end

  object :annotation do
    field(:id, non_null(:id))
    field(:text, non_null(:string))
    field(:verse_id, non_null(:id))
    field(:verse, non_null(:verse), resolve: dataloader(Bible.Verse))
    field(:user_id, non_null(:id))
    field(:user, non_null(:user), resolve: dataloader(Auth.User))

    field(:inserted_at, non_null(:datetime))
    field(:updated_at, non_null(:datetime))
    field(:deleted_at, :datetime)
  end

  input_object :save_annotation_input do
    field :id, :id
    field :text, non_null(:string)
    field :verse_id, non_null(:id)

    field :inserted_at, :datetime
    field :updated_at, :datetime
    field :deleted_at, :datetime
  end

  input_object :sync_annotations_input do
    field :annotations, non_null(list_of(:save_annotation_input))
    field :last_synced_at, non_null(:datetime) 
  end

  object :save_annotation_payload do
    field :annotation, non_null(:annotation)
  end

  object :save_annotations_paylaod do
    field :annotations, non_null(list_of(:annotation))
  end

  object :sync_annotations_payload do
    field :annotations, non_null(list_of(:annotation))
  end
end
