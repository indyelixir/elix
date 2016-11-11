defmodule RedixMock do

  @process :redix
  @list_data %{
    "Groceries" => [
      "platypus milk"
    ],
    "PLIBMTLBHGATY" => [],
    "Places to Visit" => [
      "Indianapolis",
      "The Moon",
      "Space"
    ]
  }

  def command!(@process, ["LRANGE", "lists", 0, -1]) do
    Map.keys(@list_data)
  end

  def command!(@process, ["RPUSH", "lists", "Places to Visit"]) do
    3
  end

  def command!(@process, ["LRANGE", "lists:places-to-visit", 0, -1]) do
    @list_data["Places to Visit"]
  end

  def command!(@process, ["LREM", "lists", 0, "Places to Visit"]) do
    1
  end

  def command!(@process, ["DEL", "lists:places-to-visit"]) do
    1
  end

  def command!(@process, ["DEL", "lists:plibmtlbhgaty"]) do
    1
  end

  def command!(@process, ["LRANGE", "lists:plibmtlbhgaty", 0, -1]) do
    []
  end

  def command!(@process, ["RPUSH", "lists:groceries", "platypus milk"]) do
    1
  end

  def command!(@process, ["RPUSH", "lists:groceries", "jazzberries"]) do
    1
  end

  def command!(@process, ["LRANGE", "lists:groceries", 0, -1]) do
    @list_data["Groceries"]
  end

  def command!(@process, ["LREM", "lists:places-to-visit", 0, "The Moon"]) do
    1
  end

  def command!(@process, ["LINDEX", "lists", index]) do
    @list_data
    |> Map.keys
    |> Enum.at(index)
  end

  def command!(:redix, ["LINDEX", "lists:places-to-visit", index]) do
    @list_data["Places to Visit"] |> Enum.at(index)
  end
end
