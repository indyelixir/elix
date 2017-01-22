defmodule Elix.MessageScheduler.RedisStore do
  @moduledoc """
  A persistence interface for scheduled messages. Encodes message terms
  to binary for storage in a Redis set sorted by timestamp.
  """

  alias Elix.Brain

  @behaviour Elix.MessageScheduler.Store
  @namespace "scheduled_messages"

  @doc """
  Returns all stored scheduled messages in a list of tuples
  of Elixir terms with their integer timestamps.
  """
  def all do
    @namespace
    |> Brain.get
    |> Enum.map(&decode/1)
  end

  @doc """
  Adds a message and its timestamp to the store.
  """
  def add(tuple) do
    Brain.add(@namespace, encode(tuple))
  end

  @doc """
  Removes a message and its timestamp from the store.
  """
  def remove(tuple) do
    Brain.remove(@namespace, encode(tuple))
  end

  defp encode(message) do
    :erlang.term_to_binary(message)
  end

  defp decode(binary) do
    :erlang.binary_to_term(binary)
  end
end
