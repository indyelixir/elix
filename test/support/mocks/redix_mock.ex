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
    1
  end

  # "Places to Visit"
  def command!(@process, ["LRANGE", "lists:a4666375875a8cb9592e9a911a6a95c7", 0, -1]) do
    @list_data["Places to Visit"]
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

  def command!(@process, ["RPUSH", "lists:7c3765bf72361083d820071fb21308a9", "platypus milk"]) do
    1
  end

  def command!(@process, ["LRANGE", "lists:7c3765bf72361083d820071fb21308a9", 0, -1]) do
    @list_data["Groceries"]
  end

  def command!(@process, ["LREM", "lists:a4666375875a8cb9592e9a911a6a95c7", 0, "The Moon"]) do
    1
  end

  def command!(@process, ["LINDEX", "lists", index]) do
    @list_data
    |> Map.keys
    |> Enum.at(index)
  end
end
