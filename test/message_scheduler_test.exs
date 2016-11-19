defmodule Elix.MessageSchedulerTest do
  use ExUnit.Case
  doctest Elix.MessageScheduler

  test "sends a message" do
    assert Elix.MessageScheduler.send_at(now(), :test) == :ok

    # Actually testing this module will be a challenge...
  end

  defp now do
    :os.system_time(:seconds)
  end
end
