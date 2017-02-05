defmodule Elix.Brain.RedisStore do
  @moduledoc """
  A Redis back-end for the Brain which persists memory to disk.
  """

  @behaviour Elix.Brain.Store
  @encoded_binary_prefix "binterm:"

  def start_link do
    redis_url = System.get_env("REDIS_URL") ||
                Application.get_env(:elix, :redis_url, "redis://")

    {:ok, _pid} = Redix.start_link(redis_url, name: :redis)
  end

  @spec set(String.t, list) :: any
  def set(key, list) do
    transaction fn ->
      command!(["DEL", key])
      items = Enum.map(list, &encode_if_necsssary(&1))
      command!(["RPUSH", key] ++ items)
    end
  end

  @spec get(String.t) :: list
  def get(key) do
    list = command!(["LRANGE", key, 0, -1])
    Enum.map(list, &decode_if_necessary/1)
  end

  @spec delete(String.t) :: any
  def delete(key) do
    command!(["DEL", key])
  end

  @spec add(String.t, any) :: any
  def add(key, item) do
    command!(["RPUSH", key, encode_if_necsssary(item)])
  end

  @spec remove(String.t, any) :: any
  def remove(key, item) do
    command!(["LREM", key, 0, encode_if_necsssary(item)])
  end

  @spec at_index(String.t, integer) :: any
  def at_index(key, index) do
    item = command!(["LINDEX", key, index])
    decode_if_necessary(item)
  end

  @spec delete_all :: :ok
  def delete_all do
    command!(["FLUSHDB"])
    :ok
  end

  defp transaction(func) do
    command!(["MULTI"])
    func.()
    command!(["EXEC"])
  end

  defp encode_if_necsssary(term) when is_binary(term), do: term
  defp encode_if_necsssary(term) do
    @encoded_binary_prefix <> :erlang.term_to_binary(term)
  end

  defp decode_if_necessary(@encoded_binary_prefix <> binary) do
    :erlang.binary_to_term(binary)
  end
  defp decode_if_necessary(binary), do: binary

  defp command!(instructions) when is_list(instructions) do
    Redix.command!(:redis, instructions)
  end
end
