defmodule Elix.APIClientMock do

  def get("http://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&limit=10&q=success") do
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

  def get("http://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&limit=10&q=error") do
    {:error, "Nope!"}
  end
end
