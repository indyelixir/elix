defmodule Elix.Brain.RedisStore do
  @moduledoc """
  A general-purpose key-value storage mechanism.
  """

  # @TODO: should this handle encoding/decoding things?

  @behaviour Elix.Brain.Store

  def start_link do
    redis_url = System.get_env("REDIS_URL") || "redis://"
    {:ok, _pid} = Redix.start_link(redis_url, name: :redis)
  end

  @doc """
  Sets a key to a value
  """
  def set(key, value) when is_binary(key) do
    command!(["SET", key, value])
  end

  @doc """
  Returns all strings stored under a key
  """
  def get(key) when is_binary(key) do
    command!(["LRANGE", key, 0, -1])
    # @TODO: handle when key points to non-list
  end

  @doc """
  Deletes the value stored under a key
  """
  def delete(key) when is_binary(key) do
    command!(["DEL", key])
  end

  @doc """
  Stores an additional string under a key
  """
  def add(key, item) when is_binary(key) and is_binary(item) do
    command!(["RPUSH", key, item])
    # @TODO: handle when key points to non-list
  end

  @doc """
  Removes a string from a list stored under a key
  """
  def remove(key, item) when is_binary(key) and is_binary(item) do
    command!(["LREM", key, 0, item])
    # @TODO: handle when key points to non-list
    # @TODO: handle when item is not in list?
  end

  @doc """
  Returns the item in a list at a 0-based index
  """
  def at_index(key, index) when is_binary(key) and is_integer(index) and index >= 0 do
    command!(["LINDEX", key, index])
    # @TODO: handle when key points to non-list
    # @TODO: handle out of range
  end

  defp command!(instructions) do
    Redix.command!(:redis, instructions)
  end
end
