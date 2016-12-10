defmodule Elix.MessageSchedulerTest do
  use ExUnit.Case
  doctest Elix.MessageScheduler

  # Helpful?
  # http://joshnuss.blogspot.com/2015/10/testing-messages-with-elixir.html

  defmodule Forwarder do
    use GenServer

    def start_link(recipient) do
      GenServer.start_link(__MODULE__, recipient)
    end

    def init(recipient) do
      {:ok, recipient}
    end

    def handle_cast(message, recipient) do
      send(recipient, message)
    end
  end

  test "sends a message" do
    assert Elix.MessageScheduler.send_at(now(), :test) == :ok

    Forwarder
    # assert_receive :test, 2_000
  end

  defp now do
    :os.system_time(:seconds)
  end
end
