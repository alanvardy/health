# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :health,
  ecto_repos: [Health.Repo]

# Configures the endpoint
config :health, HealthWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "j+x2aSduBxr14DKm82XD+TMCHcgQAQsXygRsNfEPYqW8ErVK7QtvSuOKn0L8nxpH",
  render_errors: [view: HealthWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Health.PubSub, adapter: Phoenix.PubSub.PG2]

# Configure POW
config :health, :pow,
  messages_backend: HealthWeb.Pow.Messages,
  user: Health.Account.User,
  repo: Health.Repo,
  extensions: [PowPersistentSession],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  web_module: HealthWeb,
  messages_backend: HealthWeb.Pow.Messages

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
