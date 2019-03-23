defmodule NotaWeb.Router do
  use NotaWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :public do
    plug(NotaWeb.Plug.PublicPipeline)
  end

  pipeline :private do
    plug(NotaWeb.Plug.PrivatePipeline)
  end

  pipeline :absinthe do
    plug(NotaWeb.Plug.AbsintheContext)
  end

  scope "/graphql" do
    pipe_through(:api)

    forward("/", Absinthe.Plug, schema: NotaWeb.Schema)
  end

  scope "/graphiql" do
    pipe_through(:api)

    forward(
      "/",
      Absinthe.Plug.GraphiQL,
      schema: NotaWeb.Schema,
      interface: :playground
    )
  end
end
