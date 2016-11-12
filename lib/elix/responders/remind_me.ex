defmodule Elix.Responders.RemindMe do
  @moduledoc """
  Ask the chatbot to remind you in the future of something.
  """

  use Hedwig.Responder
  alias Hedwig.Message

  @usage """
  remind me to <thing> in <time> - Sets a reminder
  """
  hear ~r/remind me to (.+) in (.+) seconds/i, %Hedwig.Message{matches: %{1 => subject, 2 => time_string}} = msg do
    remind_at_timestamp = :os.system_time(:seconds) + String.to_integer(time_string)
    Elix.Reminder.enqueue(subject, remind_at_timestamp, msg)

    reply(msg, "Okay, I’ll remind you to #{subject} in #{time_string} seconds.")
  end
end
