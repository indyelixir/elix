defmodule Elix.Responders.AchievementUnlocked do
  @moduledoc """
  Returns an appropriate image URL from
  http://achievement-unlocked.herokuapp.com
  """

  use Hedwig.Responder
  alias Hedwig.Message

  @usage """
  <User> unlock[|s|ed] achievement <Achievement> - Replies with an image URL
  """
  hear ~r/(.+) unlocks?(?:ed)? achievement (.+)/i, %Message{matches: matches} = msg do
    reply(msg, image_url(matches[2]))
  end

  defp image_url(achievement) do
    base_url = "http://achievement-unlocked.herokuapp.com/xbox/"
    path = URI.encode(achievement)
    query_string = build_query_string

    "\n\n" <> base_url <> path <> ".jpg?" <> query_string
  end

  defp build_query_string do
    URI.encode_query(%{
      header: "ACHIEVEMENT%20UNLOCKED",
      email: "xbox@indyelixir.org"
    })
  end
end
