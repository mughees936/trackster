defmodule Trackster.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TracksterWeb.Telemetry,
      Trackster.Repo,
      {DNSCluster, query: Application.get_env(:trackster, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Trackster.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Trackster.Finch},
      # Start a worker by calling: Trackster.Worker.start_link(arg)
      {Trackster.Workers.TrackingsHandler, []},
      # Start to serve requests, typically the last entry
      TracksterWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Trackster.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TracksterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
