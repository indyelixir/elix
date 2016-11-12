defmodule Elix.Responders.RemindMe do
  @moduledoc """
  Ask the chatbot to remind you in the future of something.
  """

  use Hedwig.Responder
  alias Hedwig.Message

  @usage """
  remind me to <thing> in <time> - Sets a reminder
  """
  respond ~r/remind me to (.+) in (.+)/i, %Message{matches: %{1 => subject, 2 => raw_time}} = msg do
    reply(msg, "Okay, I’ll remind you to #{subject} in #{raw_time}")
  end
end
