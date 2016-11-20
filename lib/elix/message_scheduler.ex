defmodule Elix.MessageScheduler do
  @moduledoc """
  Enables scheduling and sending chat messages in the future.
  """
  use GenServer

  @namespace "scheduled_messages"

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
    state_from_store =
      Redix.command!(:redix, ["ZRANGE", @namespace, 0, -1, "WITHSCORES"])
      |> Stream.chunk(2)
      |> Enum.map(fn([binary_message, timestamp_string]) ->
           {:erlang.binary_to_term(binary_message), String.to_integer(timestamp_string)}
         end)

    heartbeat()
    {:noreply, state_from_store}
  end

  def handle_cast({:schedule, {message, timestamp} = scheduled_message}, state) do
    message_bin = :erlang.term_to_binary(message)
    Redix.command!(:redix, ["ZADD", @namespace, timestamp, message_bin])

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
             message_bin = :erlang.term_to_binary(message)
             Redix.command!(:redix, ["ZREM", @namespace, message_bin])
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
