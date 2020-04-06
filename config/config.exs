# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sea_world_interface,
  ecto_repos: [SeaWorldInterface.Repo]

# Configures the endpoint
config :sea_world_interface, SeaWorldInterfaceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eXsUcbcttCt2tvLcSG4JaGrqhiIBo4q1mRbZx1Naa5GYm+GA+FBjmT/jFWJQNf7b",
  render_errors: [view: SeaWorldInterfaceWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SeaWorldInterface.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "HKhmwUeC"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
