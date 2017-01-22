defmodule Elix.Brain do
  @moduledoc """
  A general-purpose key-value storage mechanism.
  """

  # @TODO: should this handle encoding/decoding things?

  use GenServer

  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, state, [name: __MODULE__])
  end

  def add(key, item) do
    GenServer.cast(__MODULE__, {:add, key, item})
  end

  # is this just get?
  def all(key) do
    GenServer.call(__MODULE__, {:all, key})
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

  def handle_call({:all, key}, _from, state) do
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
