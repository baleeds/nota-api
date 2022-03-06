defmodule NotaWeb.Schema.AnnotationReplies do
  import AbsintheErrorPayload.Payload

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias NotaWeb.Resolvers.AnnotationReplies

  alias Nota.Models

  connection(node_type: :annotation_reply)

  node object(:annotation_reply) do
    field(:text, non_null(:string))
    field(:annotation_id, non_null(:id))
    field(:user_id, non_null(:id))
    field(:inserted_at, non_null(:datetime))
    field(:updated_at, non_null(:datetime))

    field(:annotation, non_null(:annotation), resolve: dataloader(Models.Annotation))
    field(:user, non_null(:user), resolve: dataloader(Models.User))
  end

  object :annotation_replies_queries do
    connection field(:annotation_replies, node_type: :annotation_reply) do
      arg(:annotation_id, :id)

      middleware(Absinthe.Relay.Node.ParseIDs, annotation_id: :annotation)

      resolve(&AnnotationReplies.get_annotation_replies/3)
    end
  end

  input_object :save_annotation_reply_input do
    field(:id, :id)
    field(:text, non_null(:string))
    field(:annotation_id, non_null(:id))
  end

  payload_object(:save_annotation_reply_payload, :annotation_reply)

  payload_object(:delete_annotation_reply_payload, :boolean)

  object :annotation_replies_mutations do
    field :save_annotation_reply, non_null(:save_annotation_reply_payload) do
      arg(:input, non_null(:save_annotation_reply_input))

      middleware(Absinthe.Relay.Node.ParseIDs,
        input: [id: :annotation_reply, annotation_id: :annotation]
      )

      resolve(&AnnotationReplies.save_annotation_reply/3)
    end

    field :delete_annotation_reply, non_null(:delete_annotation_reply_payload) do
      arg(:annotation_reply_id, non_null(:id))

      middleware(Absinthe.Relay.Node.ParseIDs, annotation_reply_id: :annotation_reply)

      resolve(&AnnotationReplies.delete_annotation_reply/3)
    end
  end
end
