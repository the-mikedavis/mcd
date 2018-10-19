defmodule Mcd.Application do
  use Application

  @moduledoc false

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Mcd.Repo, []),
      supervisor(McdWeb.Endpoint, []),
      worker(Mcd.Content.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: Mcd.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    McdWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
