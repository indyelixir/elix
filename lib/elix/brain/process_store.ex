defmodule Elix.Brain.ProcessStore do
  @moduledoc """
  A process-based storage mechanism for the Brain. Does not persist to disk.
  """

  @behaviour Elix.Brain.Store

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @spec set(String.t, any) :: any
  def set(key, value) do
    Agent.update(__MODULE__, &Map.put(&1, key, value))
  end

  @spec get(String.t) :: any
  def get(key) do
    Agent.get(__MODULE__, &Map.get(&1, key, []))
  end

  @spec delete(String.t) :: any
  def delete(key) do
    Agent.update(__MODULE__, &Map.delete(&1, key))
  end

  @spec add(String.t, any) :: any
  def add(key, item) do
    Agent.update(__MODULE__, fn (state) ->
      Map.update(state, key, [item], fn (list) ->
        list ++ [item]
      end)
    end)
  end

  @spec remove(String.t, any) :: any
  def remove(key, item) do
    Agent.update(__MODULE__, fn (state) ->
      Map.update(state, key, [], &List.delete(&1, item))
    end)
  end

  @spec at_index(String.t, integer) :: any
  def at_index(key, index) do
    Agent.get(__MODULE__, fn (state) ->
      state
      |> Map.get(key)
      |> Enum.at(index)
    end)
  end
end
