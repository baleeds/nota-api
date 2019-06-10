defmodule NotaWeb.Schema.Users do
  use Absinthe.Schema.Notation

  # alias Nota.Annotations

  alias NotaWeb.Resolvers.Auth.User

  # import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :user_queries do
    field :user, non_null(:user) do
      arg(:id, non_null(:id))

      resolve(&User.get/3)
    end

    field :users, list_of(non_null(:user)) do      
      resolve(&User.get_all/3)
    end
  end

  object :user do
    field(:id, non_null(:id))
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, non_null(:string))
    
    # field(:annotations, list_of(non_null(:annotation)), resolve: dataloader(Annotations.Annotation))
  end
end
