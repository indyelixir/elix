use Mix.Config

config :elix, Elix.Robot,
  adapter: Hedwig.Adapters.Test

config :elix, :redis_url, "redis://localhost:6379/3"
