defmodule Elix.Brain do
  @moduledoc """
  A general-purpose key-value storage mechanism. For simplicity, keys are always
  strings, and values are always lists, though the lists can contain any terms.
  """

  alias Elix.Brain.ProcessStore

  @store Application.get_env(:elix, :brain, ProcessStore)

  def start_link do
    @store.start_link
  end

  def set(key, val) when is_binary(key) and is_list(val) do
    @store.set(key, val)
  end

  def all(key) when is_binary(key) do
    @store.get(key) || []
  end

  def delete(key) when is_binary(key) do
    @store.delete(key)
  end

  def add(key, item) when is_binary(key) do
    @store.add(key, item)
  end

  def remove(key, item) when is_binary(key) do
    @store.remove(key, item)
  end

  def at_index(key, index) when is_binary(key)
                            and is_integer(index)
                            and index >= 0 do

    @store.at_index(key, index)
  end
end
