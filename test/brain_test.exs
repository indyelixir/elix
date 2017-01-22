defmodule Elix.BrainTest do
  use ExUnit.Case, async: true
  alias Elix.Brain

  setup do
    [{:ok, _} = Brain.start_link(%{"people" => ["Jane", "Kate"]})]
  end

  test ".all returns all items at key" do
    assert Brain.all("people") == ["Jane", "Kate"]
  end

  test ".set sets a key to a value" do
    assert Brain.all("people") == ["Jane", "Kate"]
    Brain.set("people", "José")
    assert Brain.all("people") == "José"
  end

  test ".delete deletes all items at key" do
    Brain.delete("people")

    assert Brain.all("people") == nil
  end

  test ".add adds an item to a list at the given key" do
    Brain.add("people", "Steve")

    assert Brain.all("people") == ["Jane", "Kate", "Steve"]
  end

  test ".remove removes an item from a list at the given key" do
    Brain.remove("people", "Kate")

    assert Brain.all("people") == ["Jane"]
  end

  test ".at_index gets an item from a list by key at a given index" do
    assert Brain.at_index("people", 1) == "Kate"
  end
end
