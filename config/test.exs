use Mix.Config

config :elix, Elix.Robot,
  adapter: Hedwig.Adapters.Test

config :elix, :api_client, Elix.APIClientMock
config :elix, :redis_client, RedixMock
config :elix, :message_scheduler_store, Elix.MessageScheduler.TestStore
