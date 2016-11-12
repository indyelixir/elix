defmodule Elix.Reminder do
  @moduledoc """
  What it does.
  """
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init(state) do
    heartbeat()
    {:ok, state}
  end

  # Elix.Reminder.enqueue(server, "Do the thing")
  def enqueue(pid, message) do
    GenServer.cast(pid, {:enqueue, message})
  end

  def handle_cast({:enqueue, message}, state) do
    {:noreply, [message | state]}
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:heartbeat, state) do
    IO.inspect(state)
    heartbeat() # Keep beating
    {:noreply, state}
  end

  defp heartbeat() do
    Process.send_after(self(), :heartbeat, 1_000)
  end
end
