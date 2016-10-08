defmodule Elix.Responders.GifMe do
  @moduledoc """
  Searches the Giphy public API and return the URL
  of a GIF matching the search term.
  """

  use Hedwig.Responder

  @base_url "http://api.giphy.com/v1/gifs/search"
  @api_key "dc6zaTOxFJmzC" # Giphy’s public beta API key
  @sample_size 10
  @api_client Application.get_env(:elix, :api_client)

  @usage """
  gif me <term> - Replies with a GIF URL matching the term
  """
  hear ~r/gif me (.+)/i, msg do
    reply(msg, get_gif_url(msg.matches[1]))
  end

  defp get_gif_url(search_term) do
    search_term
    |> build_api_url
    |> make_request
    |> get_random_image_url
  end

  defp build_api_url(search_term) do
    @base_url <> "?" <> build_query_string(search_term)
  end

  defp build_query_string(search_term) do
    URI.encode_query(%{
      q: search_term,
      api_key: @api_key,
      limit: @sample_size
    })
  end

  defp make_request(api_url) do
    {:ok, response} = @api_client.get(api_url)
    response
  end

  defp get_random_image_url(response) do
    Enum.random(response["data"])["images"]["original"]["url"]
  end
end
