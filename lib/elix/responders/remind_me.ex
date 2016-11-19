defmodule Elix.Responders.RemindMe do
  @moduledoc """
  Ask the chatbot to remind you in the future of something.
  """

  use Hedwig.Responder
  alias Hedwig.Message

  @usage """
  remind me to <thing> in <time> - Sets a reminder
  """
  hear ~r/remind me (.+) in (.+)/i,
    %Message{matches: %{1 => subject, 2 => time_string}, user: user} = msg do

    response =
      with {:ok, seconds} <- Elix.TimeParser.from_now(time_string) do
        seconds
        |> from_now
        |> schedule_reminder(user, subject)

        "Okay, I’ll remind you #{subject} in #{time_string}."
      else
        {:error, :parse_error} -> "Sorry, I don’t understand that time frame. You can say “Remind me [something] in [number]seconds|minutes|hours|days|weeks”."
      end

    reply(msg, response)
  end

  defp from_now(seconds) do
    :os.system_time(:seconds) + seconds
  end

  defp schedule_reminder(timestamp, user, subject) do
    user
    |> build_reminder_about(subject)
    |> to_reply_tuple
    |> Elix.MessageScheduler.send_at(timestamp)
  end

  defp to_reply_tuple(message), do: {:reply, message}

  defp build_reminder_about(user, subject) do
    %Message{
      user: user,
      text: "You asked me to remind you #{subject}.",
      type: "chat"
    }
  end
end
