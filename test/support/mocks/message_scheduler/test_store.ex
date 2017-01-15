defmodule Elix.MessageScheduler.TestStore do
  @moduledoc """
  A mock message store for use in tests. Does not actually persist anything.
  """

  @behaviour Elix.MessageScheduler.Store

  def all, do: []

  def add(_message, _timestamp), do: :ok

  def remove(_message), do: :ok
end
