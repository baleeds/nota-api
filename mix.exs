defmodule Nota.Mixfile do
  use Mix.Project

  def project do
    [
      app: :nota,
      version: "0.0.1",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Nota.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :ueberauth,
        :ueberauth_google,
        :corsica,
        :guardian
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:absinthe, ">= 1.5.0"},
      {:absinthe_error_payload, "~> 1.1.3"},
      {:absinthe_phoenix, "~> 2.0"},
      {:absinthe_plug, ">= 1.5.0"},
      {:absinthe_relay, ">= 1.5.0"},
      {:argon2_elixir, "~> 2.3.0"},
      {:bamboo, "~> 1.1"},
      {:corsica, "~> 1.0"},
      {:dataloader, "~> 1.0.0"},
      {:ecto_sql, "~> 3.4"},
      {:guardian, "~> 2.1.1"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:phoenix, "~> 1.5.3"},
      {:phoenix_ecto, "~> 4.1"},
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 4.0.1"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_dashboard, "~> 0.2.0"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:secure_random, "~> 0.5"},
      {:ueberauth, "~> 0.6.2"},
      {:ueberauth_facebook, "~> 0.8"},
      {:ueberauth_google, "~> 0.9"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
