defmodule Elix.Responders.GifMe do
  @moduledoc """
  Searches the Giphy public API and return the URL
  of a GIF matching the search term.
  """

  use Hedwig.Responder

  @base_url "http://api.giphy.com/v1/gifs/search"
  @api_key "dc6zaTOxFJmzC" # Giphy’s public beta API key
  @sample_size 10

  @usage """
  gif me <term> - Replies with a GIF URL matching the term
  """
  hear ~r/gif me (.+)/i, msg do
    api_url = build_api_url(msg.matches[0])
    response = make_request(api_url)

    reply(msg, response)
  end

  defp build_api_url(search_term) do
    "#{@base_url}?q=#{URI.encode(search_term)}&api_key=#{@api_key}&limit=#{@sample_size}"
  end

  defp make_request(api_url) do
    {:ok, response} = HTTPoison.get(api_url)
    parsed_response = Poison.decode!(response.body)
    first_image = Enum.random(parsed_response["data"])
    first_image["images"]["original"]["url"]
  end
end
