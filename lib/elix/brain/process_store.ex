defmodule Elix.Brain.ProcessStore do
  @moduledoc """
  A process-based storage mechanism for the Brain. Does not persist to disk.
  """

  @behaviour Elix.Brain.Store

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def set(key, value) do
    Agent.update(__MODULE__, fn (state) ->
      Map.put(state, key, value)
    end)
  end

  def get(key) do
    Agent.get(__MODULE__, fn (state) ->
      Map.get(state, key, [])
    end)
  end

  def delete(key) do
    Agent.update(__MODULE__, fn (state) ->
      Map.delete(state, key)
    end)
  end

  def add(key, item) do
    Agent.update(__MODULE__, fn (state) ->
      Map.update(state, key, [item], fn (list) ->
        list ++ [item]
      end)
    end)
  end

  def remove(key, item) do
    Agent.update(__MODULE__, fn (state) ->
      Map.update(state, key, [], fn (list) ->
        list -- [item]
      end)
    end)
  end

  def at_index(key, index) do
    Agent.get(__MODULE__, fn (state) ->
      state
      |> Map.get(key)
      |> Enum.at(index)
    end)
  end
end
