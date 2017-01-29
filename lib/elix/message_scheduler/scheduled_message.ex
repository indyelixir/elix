defmodule Elix.MessageScheduler.ScheduledMessage do
  @moduledoc """
  A data structure and functions for scheduled messages
  """

  @enforce_keys ~w(message timestamp)a
  defstruct ~w(message timestamp)a

  def new(message, timestamp) when is_integer(timestamp) do
    %__MODULE__{message: message, timestamp: timestamp}
  end
end
