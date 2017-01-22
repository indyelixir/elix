defmodule Elix.BrainTest do
  use ExUnit.Case, async: true
  alias Elix.Brain

  test ".all returns all items at key" do
    {:ok, _} = Brain.start_link(%{"foo" => ["bar"]})
    assert Brain.all("foo") == ["bar"]
  end

  test ".add returns all items at key" do
    {:ok, _} = Brain.start_link
    assert Brain.all("people") == nil

    Brain.add("people", "Steve")

    assert Brain.all("people") == ["Steve"]
  end

  test ".delete deletes all items at key" do
    {:ok, _} = Brain.start_link(%{"foo" => ["bar"]})
    assert Brain.all("foo") == ["bar"]

    Brain.delete("foo")

    assert Brain.all("foo") == nil
  end

  test ".remove removes an item from a list" do
    {:ok, _} = Brain.start_link(%{"foo" => ["bar", "baz"]})
    assert Brain.all("foo") == ["bar", "baz"]

    Brain.remove("foo", "bar")

    assert Brain.all("foo") == ["baz"]
  end

  test ".at_index gets an item from a list by key at a given index" do
    {:ok, _} = Brain.start_link(%{"foo" => ["bar", "baz", "qux"]})

    assert Brain.at_index("foo", 1) == "baz"
  end
end
