use Mix.Config

# Configure your database
config :health, Health.Repo,
  username: "postgres",
  password: "postgres",
  database: "health_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :health, HealthWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :health, Health.Mailer,
  adapter: Bamboo.LocalAdapter

