defmodule Elix.Responders.RemindMe do
  @moduledoc """
  Ask the chatbot to remind you in the future of something.
  """

  use Hedwig.Responder
  alias Hedwig.Message

  @usage """
  remind me <thing> in <time> - Schedules a reminder
  """
  hear ~r/remind me (.+) in (.+)/i,
    %Message{matches: %{1 => subject, 2 => time_string}} = msg do

    response =
      with {:ok, seconds} <- Elix.TimeParser.from_now(time_string) do
        msg
        |> build_reply_about(subject)
        |> schedule_in(seconds)

        "Okay, I’ll remind you #{subject} in #{time_string}."
      else
        {:error, :parse_error} -> "Sorry, I don’t understand that time frame. You can say “Remind me [something] in [number]seconds|minutes|hours|days|weeks”."
      end

    reply(msg, response)
  end

  defp build_reply_about(msg, subject) do
    %Message{msg | text: "You asked me to remind you #{subject}."}
  end

  defp from_now(seconds), do: :os.system_time(:seconds) + seconds

  defp schedule_in(msg, seconds) do
    Elix.MessageScheduler.send_at({:reply, msg}, from_now(seconds))
  end
end
