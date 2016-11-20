defmodule Elix.MessageScheduler do
  @moduledoc """
  Enables scheduling and sending chat messages in the future.
  """
  use GenServer

  @store Elix.MessageScheduler.RedisStore

  def start_link do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def init(state) do
    GenServer.cast(__MODULE__, :init)
    {:ok, state}
  end

  @doc """
  Schedule a message to be sent to Elix.Robot at some future timestamp.

      iex> timestamp = :os.system_time(:seconds) + 10
      ...> Elix.MessageScheduler.send_at(timestamp, {:ping, "Steve"})
      :ok

  """
  def send_at(message, timestamp) do
    GenServer.cast(__MODULE__, {:schedule, {message, timestamp}})
  end

  def handle_cast(:init, _state) do
    heartbeat()
    {:noreply, @store.all}
  end

  def handle_cast({:schedule, {message, timestamp} = scheduled_message}, state) do
    @store.add(message, timestamp)

    {:noreply, [scheduled_message | state]}
  end

  def handle_info(:heartbeat, []) do
    # Do nothing if state is empty
    heartbeat()
    {:noreply, []}
  end
  def handle_info(:heartbeat, state) do
    new_state =
      state
      |> Stream.map(fn ({message, timestamp} = scheduled_message) ->
           if timestamp <= :os.system_time(:seconds) do
             GenServer.cast(Elix.Robot, message)
             @store.remove(message)
             nil
           else
             scheduled_message
           end
         end)
      |> Enum.reject(&is_nil/1)

    heartbeat() # Keep beating
    {:noreply, new_state}
  end

  defp heartbeat do
    Process.send_after(self(), :heartbeat, :timer.seconds(1))
  end
end
