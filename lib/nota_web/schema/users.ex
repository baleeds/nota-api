defmodule NotaWeb.Schema.Users do
  use Absinthe.Schema.Notation

  # alias Nota.Annotations

  alias NotaWeb.Resolvers.Bible.Verse

  # import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :user do
    field(:id, non_null(:id))
    field(:first_name, non_null(:string))
    field(:last_name, non_null(:string))
    field(:email, non_null(:string))
    
    # field(:annotations, list_of(non_null(:annotation)), resolve: dataloader(Annotations.Annotation))
  end
end
