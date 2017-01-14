defmodule Elix.Robot do
  use Hedwig.Robot, otp_app: :elix

  def handle_connect(state) do
    if is_nil(Process.whereis(__MODULE__)) do
      true = Process.register(self(), __MODULE__)
    end
    {:ok, state}
  end

  def handle_disconnect(_reason, state) do
    {:reconnect, 5000, state}
  end

  def handle_in(%Hedwig.Message{} = msg, state) do
    {:dispatch, msg, state}
  end

  def handle_in(_msg, state) do
    {:noreply, state}
  end
end
