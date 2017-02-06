use Mix.Config

config :elix, Elix.Robot,
  adapter: Hedwig.Adapters.Flowdock,
  token: System.get_env("FLOWDOCK_TOKEN")

config :hedwig_brain, :store, Hedwig.Brain.RedisStore

config :honeybadger, :environment_name, :prod
