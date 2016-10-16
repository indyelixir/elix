defmodule Elix.Lists do

  @namespace "lists"

  def all do
    {:ok, lists} = Redix.command(:redix, ["LRANGE", @namespace, 0, -1])
    lists
  end

  def create(list_name) do
    {:ok, _length} = Redix.command(:redix, ["RPUSH", @namespace, list_name])
    all
  end

  def delete(list_name) do
    {:ok, _length} = Redix.command(:redix, ["LREM", @namespace, 0, list_name])
    all
  end

end
