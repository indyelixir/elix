use Mix.Config

config :elix, Elix.Robot,
  adapter: Hedwig.Adapters.Test

config :elix, :message_scheduler_store, Elix.MessageScheduler.TestStore
