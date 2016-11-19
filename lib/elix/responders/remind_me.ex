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
                                          user: user
                                        } = msg do

    response =
      with {:ok, seconds_from_now} <- Elix.TimeParser.from_now(time_string) do
        remind_at_timestamp = :os.system_time(:seconds) + seconds_from_now
        message = {:reply, %Hedwig.Message{
          user: user,
          text: "You asked me to remind you #{subject}.",
          type: "chat"
        }}
        Elix.ScheduledMessage.enqueue(message, remind_at_timestamp)
        "Okay, I’ll remind you #{subject} in #{time_string}."
      else
        {:error, :parse_error} -> "Sorry, I don’t understand that time frame. You can say “Remind me [something] in [number]seconds|minutes|hours|days|weeks”."
      end

    reply(msg, response)
  end
end
