defmodule Elix.Responders.RemindMe do
  @moduledoc """
  Ask the chatbot to remind you in the future of something.
  """

  use Hedwig.Responder
  alias Hedwig.Message

  @usage """
  remind me to <thing> in <time> - Sets a reminder
  """
  hear ~r/remind me (.+) in (.+)/i, %Message{
                                         matches: %{
                                           1 => subject,
                                           2 => time_string
                                          },
                                          user: user_name
                                        } = msg do

    seconds_from_now = Elix.TimeParser.from_now(time_string)
    remind_at_timestamp = :os.system_time(:seconds) + seconds_from_now

    future_reply = "You asked me to remind you #{subject}."
    Elix.Reminder.enqueue(future_reply, remind_at_timestamp, user_name)

    reply(msg, "Okay, I’ll remind you #{subject} in #{time_string}.")
  end
end
