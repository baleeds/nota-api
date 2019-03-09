defmodule NotaWeb.Schema do
  use Absinthe.Schema

  alias Nota.Nota

  import_types(__MODULE__.Nota)

  query do
    import_fields(:pets_queries)
    # import_fields(:galleries_queries)
  end

  mutation do
    import_fields(:pets_mutations)
    # import_fields(:galleries_mutations)
  end

  def context(ctx) do
    loader =
      Dataloader.new
      |> Dataloader.add_source(Nota.Pet, Nota.data())
      |> Dataloader.add_source(Nota.Owner, Nota.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
