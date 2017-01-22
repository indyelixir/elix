defmodule Elix.Brain do
  @moduledoc """
  A general-purpose key-value storage mechanism.
  """

  # @TODO: should this handle encoding/decoding things?

  @doc """
  Returns all strings stored under a key
  """
  def all(key) when is_binary(key) do
    command!(["LRANGE", key, 0, -1])
    # @TODO: handle when key points to non-list
  end

  @doc """
  Stores an additional string under a key
  """
  def add(key, item) when is_binary(key) and is_binary(item) do
    command!(["RPUSH", key, item])
    # @TODO: handle when key points to non-list
  end

  @doc """
  Removes a string stored under a key
  """
  def remove(key, item) when is_binary(key) and is_binary(item) do
    command!(["LREM", key, 0, item])
    # @TODO: handle when key points to non-list
    # @TODO: handle when item is not in list?
  end

  defp command!(instructions) do
    Redix.command!(:redix, instructions)
  end
end
