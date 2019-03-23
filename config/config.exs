# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :nota,
  ecto_repos: [Nota.Repo]

# Configures the endpoint
config :nota, NotaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HmbY4BSibMF8QYcHGeG7xHhj0BHle+OiCsoT0vsx5+S8kpqPBsOsobCzDhOOCuch",
  render_errors: [view: NotaWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Nota.PubSub, adapter: Phoenix.PubSub.PG2]

# Guardian
config :nota, Nota.Auth.Guardian,
  issuer: "nota",
  secret_key: System.get_env("JWT_SECRET_KEY"),
  ttl: {12, :hours},
  allowed_algos: ["HS256"]

config :nota, Nota.Auth.AccessPipeline,
  module: Nota.Auth.Guardian,
  error_handler: Nota.Auth.ErrorHandler

# Ueberauth
config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
