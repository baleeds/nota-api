defmodule PetsWeb.Schema do
  use Absinthe.Schema

  alias Pets.Pets

  import_types(__MODULE__.Pets)

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
      |> Dataloader.add_source(Pets.Pet, Pets.data())
      |> Dataloader.add_source(Pets.Owner, Pets.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
