use Mix.Config

config :elix, Elix.Robot,
  adapter: Hedwig.Adapters.Console

config :elix, :giphy_client, Elix.GiphyClient
