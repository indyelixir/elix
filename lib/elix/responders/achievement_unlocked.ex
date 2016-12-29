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
    reply(msg, image_url(matches[1], matches[2]))
  end

  defp image_url(user, achievement) do
    base_url = "http://achievement-unlocked.herokuapp.com/xbox/"
    path = URI.encode(achievement)
    query_string = build_query_string(user)

    base_url <> path <> "?" <> query_string
  end

  defp build_query_string(user) do
    URI.encode_query(%{
      header: "ACHIEVEMENT%20UNLOCKED",
      # email: user.emai
    })
  end
  #
  # defp make_request(api_url) do
  #   @api_client.get(api_url)
  # end
  #
  # defp handle_response({:ok, response}) do
  #   Enum.random(response["data"])["images"]["original"]["url"]
  # end
  # defp handle_response({:error, _reason}) do
  #   "I’m sorry, Giphy isn’t talking to me right now."
  # end
end
