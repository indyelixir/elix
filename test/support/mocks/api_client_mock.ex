defmodule Elix.APIClientMock do

  def get(_) do
    {:ok,
      %{
        "data" => [
          %{
            "images" => %{
              "original" => %{
                "url" => "http://giphy.com/test.gif"
              }
            }
          }
        ]
      }
    }
  end
end
