defmodule Elix.Robot do
  use Hedwig.Robot, otp_app: :elix

  def handle_connect(state) do
    if is_nil(Process.whereis(__MODULE__)) do
      true = Process.register(self(), __MODULE__)
    end
    {:ok, state}
  end

end
