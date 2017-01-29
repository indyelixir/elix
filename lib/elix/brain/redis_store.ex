defmodule Elix.Brain.RedisStore do
  @moduledoc """
  A Redis back-end for the Brain which persists memory to disk.
  """

  @behaviour Elix.Brain.Store
  @encoded_binary_prefix "bin:"

  def start_link do
    redis_url = System.get_env("REDIS_URL") || "redis://"
    {:ok, _pid} = Redix.start_link(redis_url, name: :redis)
  end

  def set(key, list) do
    command!(["DEL", key])
    Enum.each(list, fn (item) ->
      command!(["RPUSH", key, encode_if_necsssary(item)])
    end)
  end

  def get(key) do
    list = command!(["LRANGE", key, 0, -1])
    Enum.map(list, &decode_if_necessary/1)
  end

  def delete(key) do
    command!(["DEL", key])
  end

  def add(key, item) do
    command!(["RPUSH", key, encode_if_necsssary(item)])
  end

  def remove(key, item) do
    command!(["LREM", key, 0, encode_if_necsssary(item)])
  end

  def at_index(key, index) do
    item = command!(["LINDEX", key, index])
    decode_if_necessary(item)
  end

  def encode_if_necsssary(term) do
    if is_binary(term) do
      term
    else
      @encoded_binary_prefix <> :erlang.term_to_binary(term)
    end
  end

  def decode_if_necessary(@encoded_binary_prefix <> binary) do
    :erlang.binary_to_term(binary)
  end
  def decode_if_necessary(binary), do: binary

  defp command!(instructions) when is_list(instructions) do
    Redix.command!(:redis, instructions)
  end
end
