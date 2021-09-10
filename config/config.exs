# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :my_chat, MyChatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "J9WK2iuhERHvHls2qLFKZOJHyoarb+09ULgkQGkHZJ5EKJOFj4CDP+HsARn/CGf/",
  render_errors: [view: MyChatWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: MyChat.PubSub,
  live_view: [signing_salt: "YBuYZ56y"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
