defmodule Elix.APIClient do
  @moduledoc """
  A general-purpose client for making HTTP requests to JSON APIs.
  """

  alias HTTPoison.Response
  alias HTTPoison.Error

  @doc """
  Makes a GET request to a public API endpoint, returning a status tuple.
  """
  def get(url) do
    HTTPoison.get(url)
    |> handle_response()
  end

  defp handle_response({:ok, %Response{body: body}}), do: Poison.decode(body)
  defp handle_response({:error, %Error{reason: reason}}), do: {:error, reason}
end
