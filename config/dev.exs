use Mix.Config

config :elix, Elix.Robot,
  adapter: Hedwig.Adapters.Console

config :elix, :api_client, Elix.APIClient

config :elix, :redis_client, Redix
