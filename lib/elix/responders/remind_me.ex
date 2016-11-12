defmodule Elix.Responders.RemindMe do
  @moduledoc """
  Ask the chatbot to remind you in the future of something.
  """

  use Hedwig.Responder
  alias Hedwig.Message

  @usage """
  remind me to <thing> in <time> - Sets a reminder
  """
  hear ~r/remind me to (.+) in (.+)/i, %Hedwig.Message{matches: %{1 => subject, 2 => time_string}, robot: robot_pid} = msg do
    Elix.Reminder.enqueue(subject)

    reply(msg, "Okay, I’ll remind you to #{subject} in #{time_string}.")
  end
end
