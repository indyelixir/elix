defmodule Elix.Brain do
  @moduledoc """
  A general-purpose key-value storage mechanism. For simplicity, keys are always
  strings, and values are always lists, though the lists can contain any terms.

  By default, state is held by a GenServer store, but other store options may
  provide long-term persistence.
  """

  alias Elix.Brain.ProcessStore

  @store Application.get_env(:elix, :brain, ProcessStore)

  defdelegate start_link, to: @store

  @doc """
  Stores a list at the given key, overwriting the existing value if present.
  """
  @spec set(String.t, list) :: any
  def set(key, val) when is_binary(key) and is_list(val) do
    @store.set(key, val)
  end

  @doc """
  Returns the list stored at the given key, or an empty list if none is there.
  """
  @spec get(String.t) :: list
  def get(key) when is_binary(key) do
    @store.get(key) || []
  end

  @doc """
  Stores a list at the given key, overwriting the existing value if present.
  """
  @spec delete(String.t) :: any
  def delete(key) when is_binary(key) do
    @store.delete(key)
  end

  @doc """
  Appends a term to the list stored at the given key.
  """
  @spec add(String.t, any) :: any
  def add(key, item) when is_binary(key) do
    @store.add(key, item)
  end

  @doc """
  Removes a term from the list stored at the given key.
  """
  @spec remove(String.t, any) :: any
  def remove(key, item) when is_binary(key) do
    @store.remove(key, item)
  end

  @doc """
  Returns the term with the given index from the list stored at the given key.
  """
  @spec at_index(String.t, integer) :: any
  def at_index(key, index) when is_binary(key)
                            and is_integer(index)
                            and index >= 0 do

    @store.at_index(key, index)
  end
end
