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
  url: [host: System.get_env("HOST"), port: System.get_env("PORT")],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: NotaWeb.ErrorView, accepts: ~w(json)],
  # pubsub: Nota.PubSub,
  live_view: [signing_salt: "LFzSDAuJ"]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :nota, frontend_url: System.get_env("FRONTEND_URL")

# Guardian
config :nota, Nota.Services.Auth.Guardian,
  issuer: "nota",
  secret_key: System.get_env("JWT_SECRET_KEY"),
  ttl: {4, :weeks},
  allowed_algos: ["HS256"]

config :nota, Nota.Services.Auth.AccessPipeline,
  module: Nota.Services.Auth.Guardian,
  error_handler: Nota.Services.Auth.ErrorHandler

# Ueberauth
config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile", access_type: "offline"]}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :nota, Nota.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD"),
  database: System.get_env("DB_NAME"),
  hostname: System.get_env("DB_HOSTNAME"),
  pool_size: 10

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
