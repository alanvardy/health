use Mix.Config

# Configure your database
config :health, Health.Repo,
  username: "postgres",
  password: "postgres",
  database: "health_systemtest",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :health, HealthWeb.Endpoint,
  http: [port: 5000],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

config :health, Health.Email, adapter: Bamboo.LocalAdapter
