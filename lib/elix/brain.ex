defmodule Elix.Brain do
  @moduledoc """
  A general-purpose key-value storage mechanism.
  """

  # @TODO: should this handle encoding/decoding things?

  @redis_client Application.get_env(:elix, :redis_client)

  @doc """
  Returns all strings stored under a key
  """
  def all(key) when is_binary(key) do
    command!(["LRANGE", key, 0, -1])
    # @TODO: handle when key points to non-list
  end

  @doc """
  Deletes the string or list stored under a key
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
    @redis_client.command!(:redix, instructions)
  end
end
