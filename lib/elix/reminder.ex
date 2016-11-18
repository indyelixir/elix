defmodule Elix.Reminder do
  @moduledoc """
  What it does.
  """
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def init(state) do
    heartbeat()
    {:ok, state}
  end

  def enqueue(subject, remind_at_timestamp, user_name) do
    GenServer.cast(__MODULE__, {:enqueue, {subject, remind_at_timestamp, user_name}})
  end

  def handle_cast({:enqueue, reminder}, state) do
    {:noreply, [reminder | state]}
  end

  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:heartbeat, state) do
    new_state =
      state
      |> Enum.map(fn ({subject, timestamp, user_name} = reminder) ->
           if timestamp <= :os.system_time(:seconds) do
             GenServer.cast(Elix.Robot, {:reply, %Hedwig.Message{
               type: "chat",
               text: subject,
               user: user_name
             }})
             nil
           else
             reminder
           end
         end)
      |> Enum.reject(&is_nil/1)

    heartbeat() # Keep beating
    {:noreply, new_state}
  end

  defp heartbeat() do
    Process.send_after(self(), :heartbeat, :timer.seconds(1))
  end
end
