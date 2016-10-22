defmodule Elix.Lists do
  @moduledoc """
  An interface for manipulating lists of items in Redis.
  """

  @namespace "lists"
  @redis_client Application.get_env(:elix, :redis_client)
  @process :redix

  @doc """
  Returns a list of all lists by name.

      iex> Elix.Lists.all
      ["Groceries", "PLIBMTLBHGATY", "Places to Visit"]

  """
  def all do
    @redis_client.command!(@process, ["LRANGE", lists_key, 0, -1])
  end

  @doc """
  Creates a new list by name, returning 1 if successful.
  """
  def create(list_name) do
    @redis_client.command!(@process, ["RPUSH", lists_key, list_name])
  end

  @doc """
  Deletes a list by name as well as its items, returning 1 if successful.
  """
  def delete(list_name) do
    @redis_client.command!(@process, ["LREM", lists_key, 0, list_name])
    clear_items(list_name)
  end

  @doc """
  Returns a list of all items in the named list.
  """
  def get_items(list_name) do
    @redis_client.command!(@process, ["LRANGE", list_key(list_name), 0, -1])
  end

  @doc """
  Adds an item to a list by name, returning 1 if successful.
  """
  def add_item(list_name, item_name) do
    @redis_client.command!(@process, ["RPUSH", list_key(list_name), item_name])
  end

  @doc """
  Deletes an item from a list by name, returning 1 if successful.
  """
  def delete_item(list_name, item_name) do
    @redis_client.command!(@process, ["LREM", list_key(list_name), 0, item_name])
  end

  @doc """
  Removes all items from a list by name, returning 1 if successful.
  """
  def clear_items(list_name) do
    @redis_client.command!(@process, ["DEL", list_key(list_name)])
  end

  @doc """
  Returns the name of a list, given its 1-based index in Lists.all.

      iex> Elix.Lists.get_name(2)
      "PLIBMTLBHGATY"

  """
  def get_name(list_num) when is_integer(list_num) and list_num > 0 do
    @redis_client.command!(@process, ["LINDEX", lists_key, list_num - 1])
  end

  @doc """
  Returns the name of an item, given its 1-based index in the named list.

      iex> Elix.Lists.get_item_name(1, "Places to Visit")
      "Indianapolis"

  """
  def get_item_name(item_num, list_name) when is_binary(list_name)
                                          and is_integer(item_num)
                                          and item_num > 0 do

    @redis_client.command!(@process, ["LINDEX", list_key(list_name), item_num - 1])
  end

  defp lists_key do
    @namespace
  end

  defp list_key(list_name) do
    "#{lists_key}:#{to_key(list_name)}"
  end

  defp to_key(name) do
    Regex.replace(~r/\W/, String.downcase(name), "-")
  end
end
