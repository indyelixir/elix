defmodule Elix.MessageSchedulerTest do
  use ExUnit.Case
  doctest Elix.MessageScheduler

  test "sends a message" do
    assert :ok = Elix.MessageScheduler.send_at(now(), :test)
  end

  defp now do
    :os.system_time(:seconds)
  end
end
