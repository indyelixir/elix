defmodule RedixMock do

  @process :redix

  def command!(@process, ["LRANGE", "lists", 0, -1]) do
    ["Groceries", "PLIBMTLBHGATY", "Places to Visit"]
  end

  def command!(@process, ["RPUSH", "lists", "Places to Visit"]) do
    1
  end

  def command!(@process, ["LRANGE", "lists:a4666375875a8cb9592e9a911a6a95c7", 0, -1]) do
    ["Indianapolis", "The Moon", "Lake Chargoggagoggmanchauggagoggchaubunagungamaugg"]
  end

  def command!(@process, ["LREM", "lists", 0, "Places to Visit"]) do
    1
  end

  def command!(@process, ["DEL", "lists:a4666375875a8cb9592e9a911a6a95c7"]) do
    1
  end

  def command!(@process, ["DEL", "lists:e0936cf924697d9af0300aa30471698e"]) do
    1
  end

  def command!(@process, ["LRANGE", "lists:e0936cf924697d9af0300aa30471698e", 0, -1]) do
    []
  end

  def command!(:redix, ["RPUSH", "lists:7c3765bf72361083d820071fb21308a9", "platypus milk"]) do
    1
  end

  def command!(:redix, ["LRANGE", "lists:7c3765bf72361083d820071fb21308a9", 0, -1]) do
    ["platypus milk"]
  end

  def command!(:redix, ["LREM", "lists:c097f64a16edb8864b5383686a128735", 0, "get my Elixir book back from Miles"]) do
    1
  end

  def command!(:redix, ["LRANGE", "lists:c097f64a16edb8864b5383686a128735", 0, -1]) do
    ["Teach a robot to feel"]
  end
end
