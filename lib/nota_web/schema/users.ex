defmodule NotaWeb.Schema.Users do
  import AbsintheErrorPayload.Payload

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias NotaWeb.Resolvers.Auth.User

  # import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  connection(node_type: :user)

  node object(:user) do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, non_null(:string))

    # field(:annotations, list_of(non_null(:annotation)), resolve: dataloader(Annotations.Annotation))
  end

  object :user_queries do
    field :user, non_null(:user) do
      arg(:id, non_null(:id))

      resolve(&User.get_user/3)
    end

    # connection field(:users, node_type: :user) do
    #   resolve(&User.get_users/3)
    # end

    field :me, :user do
      resolve(&User.get_me/3)
    end
  end

  object :user_mutations do
    field :refresh_token, non_null(:string) do
      arg(:token, non_null(:string))

      resolve(&User.refresh_token/3)
    end
  end
end
