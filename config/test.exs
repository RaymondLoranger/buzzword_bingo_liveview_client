import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :buzzword_bingo_liveview_client,
       Buzzword.Bingo.Liveview.ClientWeb.Endpoint,
       http: [ip: {127, 0, 0, 1}, port: 4002],
       secret_key_base:
         "HwwSRSdGzl0P6InVZiZrq+UTgA+gVB1B3BmyXh4yGiNCTnpz+eyidL8sGAsR8VI1",
       server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
