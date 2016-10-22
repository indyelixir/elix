defmodule Elix.Lists do

  @namespace "lists"
  @redis_client Application.get_env(:elix, :redis_client)
  @process :redix

  def all do
    @redis_client.command!(@process, ["LRANGE", lists_key, 0, -1])
  end

  def create(list_name) do
    @redis_client.command!(@process, ["RPUSH", lists_key, list_name])
  end

  def delete(list_name) do
    @redis_client.command!(@process, ["LREM", lists_key, 0, list_name])
    clear_items(list_name)
  end

  def get_items(list_name) do
    @redis_client.command!(@process, ["LRANGE", list_key(list_name), 0, -1])
  end

  def add_item(list_name, item_name) do
    @redis_client.command!(@process, ["RPUSH", list_key(list_name), item_name])
  end

  def delete_item(list_name, item_name) do
    @redis_client.command!(@process, ["LREM", list_key(list_name), 0, item_name])
  end

  def clear_items(list_name) do
    @redis_client.command!(@process, ["DEL", list_key(list_name)])
  end

  def get_name(list_num) when is_integer(list_num) and list_num > 0 do
    @redis_client.command!(@process, ["LINDEX", lists_key, list_num - 1])
  end

  def get_item_name(item_num, list_name) when is_binary(list_name)
                                          and is_integer(item_num)
                                          and item_num > 0 do

    @redis_client.command!(@process, ["LINDEX", list_key(list_name), item_num - 1])
  end

  defp lists_key do
    @namespace
  end

  defp list_key(list_name) do
    "#{lists_key}:#{to_key(list_name)}"
  end

  defp to_key(name) do
    Regex.replace(~r/\W/, String.downcase(name), "-")
  end
end
