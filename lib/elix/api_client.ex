defmodule Elix.APIClient do

  def get(url) do
    HTTPoison.get(url)
    |> handle_response()
  end

  defp handle_response({:ok, response}) do
    Poison.decode(response.body)
  end
  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end
