defmodule Elix.GiphyClient do

  def get(url) do
    {:ok, response} = HTTPoison.get(url)
    {:ok, Poison.decode!(response.body)}
  end
end
