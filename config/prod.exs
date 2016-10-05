use Mix.Config

config :elix, Elix.Robot,
  adapter: Hedwig.Adapters.Flowdock,
  token: System.get_env("FLOWDOCK_TOKEN")

config :elix, :giphy_client, Elix.GiphyClient
