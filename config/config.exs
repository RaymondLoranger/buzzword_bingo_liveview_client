# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :buzzword_bingo_liveview_client,
  namespace: Buzzword.Bingo.Liveview.Client

# Configures the endpoint
config :buzzword_bingo_liveview_client,
       Buzzword.Bingo.Liveview.ClientWeb.Endpoint,
       url: [host: "localhost"],
       render_errors: [
         view: Buzzword.Bingo.Liveview.ClientWeb.ErrorView,
         accepts: ~w(html json),
         layout: false
       ],
       pubsub_server: Buzzword.Bingo.Liveview.Client.PubSub,
       live_view: [signing_salt: "wAB7v6vM"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Set Tailwind CSS version, path to config, and customize asset paths...
config :tailwind,
  version: "3.0.24",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

import_config "config_logger.exs"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
