defmodule PetsWeb.Router do
  use PetsWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/graphql" do
    pipe_through(:api)

    forward("/", Absinthe.Plug, schema: PetsWeb.Schema)
  end

  scope "/graphiql" do
    pipe_through(:api)

    forward(
      "/",
      Absinthe.Plug.GraphiQL,
      schema: PetsWeb.Schema,
      interface: :playground
    )
  end
end
