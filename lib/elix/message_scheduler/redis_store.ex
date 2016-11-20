defmodule Elix.MessageScheduler.RedisStore do
  @moduledoc """
  A persistence interface for scheduled messages. Encodes message terms
  to binary for storage in a Redis set sorted by timestamp.
  """

  @namespace "scheduled_messages"

  @doc """
  Returns all stored scheduled messages in a list of tuples
  of Elixir terms with their integer timestamps.
  """
  def all do
    Redix.command!(:redix, ["ZRANGE", @namespace, 0, -1, "WITHSCORES"])
    |> Enum.chunk(2)
    |> Enum.map(fn([binary_message, timestamp_string]) ->
         {decode(binary_message), String.to_integer(timestamp_string)}
       end)
  end

  @doc """
  Adds a message and its timestamp to the store.
  """
  def add(message, timestamp) do
    Redix.command!(:redix, ["ZADD", @namespace, timestamp, encode(message)])
  end

  @doc """
  Removes a message and its timestamp from the store.
  """
  def remove(message) do
    Redix.command!(:redix, ["ZREM", @namespace, encode(message)])
  end

  defp encode(message) do
    :erlang.term_to_binary(message)
  end

  defp decode(binary) do
    :erlang.binary_to_term(binary)
  end
end
