defmodule NotaWeb.Schema do
  use Absinthe.Schema

  alias Nota.Repo
  alias Nota.Bible
  alias Nota.Annotations


  import_types(__MODULE__.Bible)
  import_types(__MODULE__.Annotations)

  query do
    import_fields(:bible_queries)
    import_fields(:annotations_queries)
  end

  mutation do
    import_fields(:annotations_mutations)
  end

  def context(ctx) do
    loader =
      Dataloader.new
      |> Dataloader.add_source(Bible.Verse, Bible.data())
      |> Dataloader.add_source(Annotations.Annotation, Annotations.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
