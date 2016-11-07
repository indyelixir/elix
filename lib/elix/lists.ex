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
    command!(["LRANGE", lists_key, 0, -1])
  end

  @doc """
  Creates a new list by name, returning 1 if successful.
  """
  def create(list_name) do
    command!(["RPUSH", lists_key, list_name])
  end

  @doc """
  Deletes a list by name as well as its items, returning 1 if successful.
  """
  def delete(list_name) do
    command!(["LREM", lists_key, 0, list_name])
    clear_items(list_name)
  end

  @doc """
  Returns a list of all items in the named list.
  """
  def get_items(list_name) do
    command!(["LRANGE", list_key(list_name), 0, -1])
  end

  @doc """
  Adds an item to a list by name, returning 1 if successful.
  """
  def add_item(list_name, item_name) do
    command!(["RPUSH", list_key(list_name), item_name])
  end

  @doc """
  Deletes an item from a list by name, returning 1 if successful.
  """
  def delete_item(list_name, item_name) do
    command!(["LREM", list_key(list_name), 0, item_name])
  end

  @doc """
  Removes all items from a list by name, returning 1 if successful.
  """
  def clear_items(list_name) do
    command!(["DEL", list_key(list_name)])
  end

  @doc """
  Returns a status tuple with the name of a list,
  given its 1-based index in Lists.all.

      iex> Elix.Lists.get_name(2)
      {:ok, "PLIBMTLBHGATY"}

  """
  def get_name(list_num) when is_integer(list_num) and list_num > 0 do
    case command!(["LINDEX", lists_key, list_num - 1]) do
      nil  -> {:error, :list_not_found}
      name -> {:ok, name}
    end
  end

  @doc """
  Returns the name of a list, given its name, or :list_not_found if not found.
  I have to admit, this feels a little confused.
  """
  def get_by_name(list_name) do
    if list_name in all() do
      {:ok, list_name}
    else
      {:error, :list_not_found}
    end
  end

  @doc """
  Returns a status tuple with the name of an item,
  given its 1-based index in the named list.

      iex> Elix.Lists.get_item_name(1, "Places to Visit")
      {:ok, "Indianapolis"}

  """
  def get_item_name(item_num, list_name) when is_binary(list_name)
                                          and is_integer(item_num)
                                          and item_num > 0 do

    case command!(["LINDEX", list_key(list_name), item_num - 1]) do
      nil  -> {:error, :item_not_found}
      name -> {:ok, name}
    end
  end

  @doc """
  Returns the name of an item, given its list and name, or :item_not_found if not found.
  I have to admit, this also feels a little confused.
  """
  def get_item_by_name(item_name, list_name) do
    if item_name in get_items(list_name) do
      {:ok, item_name}
    else
      {:error, :item_not_found}
    end
  end

  defp command!(instructions) do
    @redis_client.command!(@process, instructions)
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
