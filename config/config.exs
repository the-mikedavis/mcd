# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :mcd,
  ecto_repos: [Mcd.Repo]

# Configures the endpoint
config :mcd, McdWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base:
    "346JR6Jb1qRYRaoXnbBanJ0rgYuWhqAOnnvky8osqvvd9x4WrJv+aTJeuBfzNBip",
  render_errors: [view: McdWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Mcd.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
