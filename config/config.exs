# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :roomx,
  ecto_repos: [Roomx.Repo]

# Configures the endpoint
config :roomx, RoomxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "33+rLGI5EQeQ782M0mf+Kpcv1+aK0Bng8fzHpQQHdXL09mvF80bxAbjcH2NA5I9M",
  render_errors: [view: RoomxWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Roomx.PubSub,
  live_view: [signing_salt: "g5DshOZc"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
