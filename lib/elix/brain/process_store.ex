defmodule Elix.Brain.ProcessStore do
  @moduledoc """
  A process-based storage mechanism for the Brain. Does not persist to disk.
  """

  @behaviour Elix.Brain.Store

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, [name: __MODULE__])
  end

  def add(key, item) do
    GenServer.cast(__MODULE__, {:add, key, item})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def set(key, val) do
    GenServer.cast(__MODULE__, {:set, key, val})
  end

  def delete(key) do
    GenServer.cast(__MODULE__, {:delete, key})
  end

  def remove(key, item) do
    GenServer.cast(__MODULE__, {:remove, key, item})
  end

  def at_index(key, index) do
    GenServer.call(__MODULE__, {:at_index, key, index})
  end

  # Callbacks

  def handle_cast({:set, key, value}, state) do
    new_state = put_in(state, [key], value)

    {:noreply, new_state}
  end
  def handle_cast({:add, key, item}, state) do
    new_state =
      Map.update(state, key, [item], fn (list) ->
        list ++ [item]
      end)

    {:noreply, new_state}
  end
  def handle_cast({:delete, key}, state) do
    {:noreply, Map.delete(state, key)}
  end
  def handle_cast({:remove, key, item}, state) do
    new_state =
      Map.update(state, key, [], fn (list) ->
        list -- [item]
      end)

    {:noreply, new_state}
  end

  def handle_call({:get, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end
  def handle_call({:at_index, key, index}, _from, state) do
    value =
      state
      |> Map.get(key)
      |> Enum.at(index)

    {:reply, value, state}
  end
end
