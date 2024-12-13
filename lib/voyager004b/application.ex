defmodule Voyager004b.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Voyager004bWeb.Telemetry,
      Voyager004b.Repo,
      {Ecto.Migrator,
        repos: Application.fetch_env!(:voyager004b, :ecto_repos),
        skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:voyager004b, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Voyager004b.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Voyager004b.Finch},
      # Start a worker by calling: Voyager004b.Worker.start_link(arg)
      # {Voyager004b.Worker, arg},
      # Start to serve requests, typically the last entry
      Voyager004bWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Voyager004b.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Voyager004bWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
