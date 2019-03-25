defmodule NotaWeb.Router do
  use NotaWeb, :router

  alias NotaWeb.Controllers.AuthController

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

  pipeline :ueberauth do
    plug(Ueberauth)
  end

  scope "/auth" do
    pipe_through([:ueberauth])

    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
    post("/:provider/callback", AuthController, :callback)
  end

  scope "/graphql" do
    pipe_through([:api, :public, :absinthe])

    forward("/", Absinthe.Plug, schema: NotaWeb.Schema)
  end

  scope "/graphiql" do
    pipe_through([:api, :absinthe])

    forward(
      "/",
      Absinthe.Plug.GraphiQL,
      schema: NotaWeb.Schema,
      interface: :playground
    )
  end
end
