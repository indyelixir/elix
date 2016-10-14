defmodule Elix.APIClientMock do
  @moduledoc """
  A mock API client for use in tests to avoid actual HTTP requests
  and to have total control over the responses. This module’s
  functionality should generally mimic Elix.APIClient.
  """

  @doc """
  Simulates the parsed JSON returned from a GET request.
  Pattern-match on the URLs requested by tests in order to
  control the response.
  """
  def get("http://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&limit=10&q=success&rating=pg-13") do
    {:ok,
      %{
        "data" => [
          %{
            "images" => %{
              "original" => %{
                "url" => "http://gifs.test/success.gif"
              }
            }
          }
        ]
      }
    }
  end
  def get("http://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&limit=10&q=error&rating=pg-13") do
    {:error, "Nope!"}
  end
end
