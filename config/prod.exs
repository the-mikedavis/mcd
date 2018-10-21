use Mix.Config

config :mcd, McdWeb.Endpoint,
  load_from_system_env: true,
  http: [port: "${MCD_PORT}"],
  url: [host: "${MCD_HOST}"],
  secret_key_base: "${MCD_SECRET_KEY_BASE}",
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true

config :mcd, Mcd.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "${MCD_DB_USERNAME}",
  password: "${MCD_DB_PASSWORD}",
  database: "${MCD_DB_DATABASE}",
  pool_size: 15

config :logger, level: :info
