use Mix.Config

config :elix, Elix.Robot,
  adapter: Hedwig.Adapters.Test

config :elix, :brain, Elix.Brain.RedisStore
