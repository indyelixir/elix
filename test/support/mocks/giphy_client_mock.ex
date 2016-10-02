defmodule Elix.GiphyClientMock do

  def get(_) do
    {:ok,
      %{
        "data" => [
          %{
            "images" => %{
              "original" => %{
                "url" => "http://test-gif-url.gif"
              }
            }
          }
        ]
      }
    }
  end
end
