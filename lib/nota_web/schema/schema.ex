defmodule NotaWeb.Schema do
  import AbsintheErrorPayload.Payload

  use Absinthe.Schema
  use Absinthe.Relay.Schema, flavor: :modern
  use Absinthe.Relay.Schema.Notation, :modern

  alias Nota.Models
  alias Nota.Services

  import_types(AbsintheErrorPayload.ValidationMessageTypes)
  import_types(Absinthe.Type.Custom)

  import_types(__MODULE__.Bible)
  import_types(__MODULE__.Annotations)
  import_types(__MODULE__.Auth)
  import_types(__MODULE__.AnnotationReplies)

  query do
    import_fields(:bible_queries)
    import_fields(:annotations_queries)
    import_fields(:auth_queries)
    import_fields(:annotation_replies_queries)
  end

  mutation do
    import_fields(:bible_mutations)
    import_fields(:annotations_mutations)
    import_fields(:auth_mutations)
    import_fields(:annotation_replies_mutations)
  end

  node interface do
    resolve_type(fn
      %Models.Annotation{}, _ ->
        :annotation

      %Models.User{}, _ ->
        :user

      %Models.AnnotationReply{}, _ ->
        :annotation_reply

      _, _ ->
        nil
    end)
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Models.Verse, Services.Bible.data())
      |> Dataloader.add_source(Models.Annotation, Services.Annotations.data())
      |> Dataloader.add_source(Models.User, Services.Auth.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  def middleware(middleware, field, %Absinthe.Type.Object{identifier: :mutation}) do
    (middleware ++
       [NotaWeb.Middleware.FormatErrorCodes, &build_payload/2])
    |> ensure_auth_unless_public(field)
  end

  def middleware(middleware, _field, _object) do
    middleware
  end

  @public_mutations [
    "sign_in",
    "create_account",
    "refresh_token",
    "send_forgot_password",
    "reset_password"
  ]

  defp ensure_auth_unless_public(middleware, %{name: name}) do
    if Enum.member?(@public_mutations, name) do
      middleware
    else
      [NotaWeb.Middleware.Auth | middleware]
    end
  end
end
