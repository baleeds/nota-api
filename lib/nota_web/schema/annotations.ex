defmodule NotaWeb.Schema.Annotations do
  import AbsintheErrorPayload.Payload

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias Nota.Bible
  alias Nota.Auth

  alias NotaWeb.Resolvers.Annotations

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  import NotaWeb.Schema.Helpers, only: [to_global_id: 1]

  connection(node_type: :annotation)

  node object(:annotation) do
    field(:text, non_null(:string))
    field(:verse_id, non_null(:id))
    field(:user_id, non_null(:id), resolve: to_global_id(:user))

    field(:is_favorite, non_null(:boolean))
    field(:inserted_at, non_null(:datetime))
    field(:updated_at, non_null(:datetime))

    field(:number_of_replies, non_null(:integer)) do
      resolve(&Annotations.get_number_of_replies/3)
    end

    field(:number_of_favorites, non_null(:integer)) do
      resolve(&Annotations.get_number_of_favorites/3)
    end

    field(:verse, non_null(:verse), resolve: dataloader(Bible.Verse))
    field(:user, non_null(:user), resolve: dataloader(Auth.User))
  end

  object :annotations_queries do
    field :annotation, non_null(:annotation) do
      arg(:id, non_null(:id))

      resolve(&Annotations.get/3)
    end

    connection field(:my_annotations, node_type: :annotation) do
      arg(:verse_id, :id)

      resolve(&Annotations.get_my_annotations/3)
    end

    connection field(:public_annotations, node_type: :annotation) do
      arg(:user_id, :id)
      arg(:verse_id, :id)

      middleware(Absinthe.Relay.Node.ParseIDs, user_id: :user)

      resolve(&Annotations.get_public_annotations/3)
    end

    connection field(:favorite_annotations, node_type: :annotation) do
      arg(:user_id, :id)

      middleware(Absinthe.Relay.Node.ParseIDs, user_id: :user)

      resolve(&Annotations.get_favorite_annotations/3)
    end
  end

  input_object :save_annotation_input do
    field(:id, :id)
    field(:text, non_null(:string))
    field(:verse_id, non_null(:id))

    field(:inserted_at, :datetime)
    field(:updated_at, :datetime)
    field(:deleted_at, :datetime)
  end

  # input_object :sync_annotations_input do
  #   field(:annotations, non_null(list_of(:save_annotation_input)))
  #   field(:last_synced_at, non_null(:datetime))
  # end

  payload_object(:save_annotation_payload, :annotation)

  payload_object(:favorite_annotation_payload, :boolean)

  payload_object(:unfavorite_annotation_payload, :boolean)

  payload_object(:delete_annotation_payload, :boolean)

  object :annotations_mutations do
    field :save_annotation, non_null(:save_annotation_payload) do
      arg(:input, non_null(:save_annotation_input))

      resolve(&Annotations.save/3)
    end

    field :delete_annotation, non_null(:delete_annotation_payload) do
      arg(:annotation_id, non_null(:id))

      middleware(Absinthe.Relay.Node.ParseIDs, annotation_id: :annotation)

      resolve(&Annotations.delete_annotation/3)
    end

    field :favorite_annotation, non_null(:favorite_annotation_payload) do
      arg(:annotation_id, non_null(:id))

      middleware(Absinthe.Relay.Node.ParseIDs, annotation_id: :annotation)

      resolve(&Annotations.favorite_annotation/3)
    end

    field :unfavorite_annotation, non_null(:unfavorite_annotation_payload) do
      arg(:annotation_id, non_null(:id))

      middleware(Absinthe.Relay.Node.ParseIDs, annotation_id: :annotation)

      resolve(&Annotations.unfavorite_annotation/3)
    end

    # field :save_annotations, non_null(:save_annotations_paylaod) do
    #   arg(:input, non_null(list_of(non_null(:save_annotation_input))))

    #   resolve(&Annotation.save_all/3)
    # end

    # field :sync_annotations, non_null(:sync_annotations_payload) do
    #   arg(:input, non_null(:sync_annotations_input))

    #   resolve(&Annotation.sync/3)
    # end
  end

  # object :save_annotation_payload do
  #   field(:annotation, non_null(:annotation))
  # end

  # object :favorite_annotation_payload do
  #   field(:success, non_null(:boolean))
  # end

  # object :unfavorite_annotation_payload do
  #   field(:success, non_null(:boolean))
  # end

  # object :save_annotations_paylaod do
  #   field(:annotations, non_null(list_of(:annotation)))
  # end

  # object :sync_annotations_payload do
  #   field(:annotations, non_null(list_of(:annotation)))
  #   field(:upserted_annotations, non_null(list_of(:annotation)))
  # end
end
