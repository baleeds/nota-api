defmodule Nota.Application do
  use Application

  def applications do
    [applications: [:bamboo]]
  end

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Nota.Repo,
      # Start the Telemetry supervisor
      NotaWeb.Telemetry,
      # Start the PubSub system
      # {Phoenix.PubSub, name: Nota.PubSub},
      # Start the Endpoint (http/https
      NotaWeb.Endpoint
      # Start a worker by calling: Lknvball.Worker.start_link(arg)
      # {Nota.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Nota.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    NotaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
