defmodule Elix.List do
  @moduledoc """
  An interface for manipulating lists of items in Redis.
  """

  defstruct name: "Untitled List", items: []

  @namespace "lists"
  @redis_client Application.get_env(:elix, :redis_client)
  @process :redix

  @doc """
  Returns a list of all lists by name.

      iex> Elix.List.all_names
      ["Groceries", "PLIBMTLBHGATY", "Places to Visit"]

  """
  def all_names do
    command!(["LRANGE", lists_key, 0, -1])
  end

  @doc """
  Creates a new list by name, returning it.
  """
  def create(list_name) do
    1 = command!(["RPUSH", lists_key, list_name])

    %__MODULE__{name: list_name, items: []}
  end

  @doc """
  Deletes a list by name as well as its items, returning :ok if successful.
  """
  def delete(%__MODULE__{name: list_name} = list) do
    clear_items(list)
    command!(["LREM", lists_key, 0, list_name])
    :ok
  end

  @doc """
  Returns a list of all items in the named list.
  """
  def get_items(%__MODULE__{name: list_name}) do
    command!(["LRANGE", list_key(list_name), 0, -1])
  end
  def get_items(list_name) do
    command!(["LRANGE", list_key(list_name), 0, -1])
  end

  @doc """
  Adds an item to a list by name, returning the updated list.
  """
  def add_item(%__MODULE__{name: list_name} = list, item_name) do
    command!(["RPUSH", list_key(list_name), item_name])

    %{list | items: list.items ++ [item_name]}
  end

  @doc """
  Deletes an item from a list by name, returning the updated list.
  """
  def delete_item(%__MODULE__{name: list_name} = list, item_name) do
    command!(["LREM", list_key(list_name), 0, item_name])

    %{list | items: list.items -- [item_name]}
  end

  @doc """
  Removes all items from a list by name, returning the updated list.
  """
  def clear_items(%__MODULE__{name: list_name} = list) do
    command!(["DEL", list_key(list_name)])

    %{list | items: []}
  end

  # @doc """
  # TODO
  # """
  # def get(list_name) when is_binary(list_name) do
  #   name = get_by_name(list_name)
  #   %__MODULE__{name: name, items: get_items(name)}
  # end
  # def get(list_index) when is_integer(list_index) and list_index > 0 do
  #   name = get_name(list_index)
  #   %__MODULE__{name: name, items: get_items(name)}
  # end

  @doc """
  Returns a status tuple with the name of a list,
  given its 1-based index in List.all_names.

      iex> Elix.List.get_by_number(2)
      {:ok, %Elix.List{name: "PLIBMTLBHGATY", items: []}}

  """
  def get_by_number(list_num) when is_integer(list_num) and list_num > 0 do
    case command!(["LINDEX", lists_key, list_num - 1]) do
      nil  -> {:error, :list_not_found}
      name -> {:ok, %__MODULE__{name: name, items: get_items(name)}}
    end
  end

  @doc """
  Returns the name of a list, given its name, or :list_not_found if not found.
  I have to admit, this feels a little confused.
  """
  def get_by_name(list_name) do
    if list_name in all_names() do
      {:ok, %__MODULE__{name: list_name, items: get_items(list_name)}}
    else
      {:error, :list_not_found}
    end
  end

  @doc """
  Returns a status tuple with the name of an item,
  given its 1-based index in the named list.

      iex> Elix.List.get_item_name(1, "Places to Visit")
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
