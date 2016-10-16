defmodule Elix.Lists do

  @namespace "lists"
  @process :redix

  def all do
    Redix.command!(@process, ["LRANGE", @namespace, 0, -1])
  end

  def create(list_name) do
    Redix.command!(@process, ["RPUSH", @namespace, list_name])
  end

  def delete(list_name) do
    Redix.command!(@process, ["LREM", @namespace, 0, list_name])
    clear_items(list_name)
  end

  def get_items(list_name) do
    Redix.command!(@process, ["LRANGE", list_key(list_name), 0, -1])
  end

  def add_item(list_name, item_name) do
    Redix.command!(@process, ["RPUSH", list_key(list_name), item_name])
  end

  def delete_item(list_name, item_name) do
    Redix.command!(@process, ["LREM", list_key(list_name), 0, item_name])
  end

  def clear_items(list_name) do
    Redix.command!(@process, ["DEL", list_key(list_name)])
  end

  defp list_key(list_name) do
    "#{@namespace}:#{hex_digest(list_name)}"
  end

  defp hex_digest(name) do
    :crypto.hash(:md5, name)
    |> Base.encode16
    |> String.downcase
  end
end
