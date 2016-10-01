defmodule Elix.Responders.GifMe do
  @moduledoc """
  Searches the Giphy public API for the search term.
  """

  # http://api.giphy.com/v1/gifs/search?q=funny+cat&api_key=dc6zaTOxFJmzC

  use Hedwig.Responder

  @usage """
  gif me <term> - Replies with a GIF for the term
  """
  hear ~r/gif me (.+)/i, msg do
    reply msg, "#{msg.matches[0]}!"
  end
end
