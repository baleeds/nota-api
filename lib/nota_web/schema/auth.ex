defmodule NotaWeb.Schema.Auth do
  # import AbsintheErrorPayload.Payload

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias NotaWeb.Resolvers.Auth

  # import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  connection(node_type: :user)

  node object(:user) do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, non_null(:string))

    # field(:annotations, list_of(non_null(:annotation)), resolve: dataloader(Annotations.Annotation))
  end

  object :auth_queries do
    field :user, non_null(:user) do
      arg(:id, non_null(:id))

      resolve(&Auth.get_user/3)
    end

    # connection field(:users, node_type: :user) do
    #   resolve(&User.get_users/3)
    # end

    field :me, :user do
      resolve(&Auth.get_me/3)
    end
  end

  object :auth_mutations do
    field :refresh_token, non_null(:string) do
      arg(:token, non_null(:string))

      resolve(&Auth.refresh_token/3)
    end
  end
end
