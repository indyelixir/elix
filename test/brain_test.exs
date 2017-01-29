defmodule Elix.BrainTest do
  use ExUnit.Case, async: true
  alias Elix.Brain

  setup do
    Brain.set("people", ["Jane", "Kate"])
  end

  describe ".get" do

    test "returns the value at a key" do
      assert Brain.get("people") == ["Jane", "Kate"]
    end

    test "returns an empty list when key is empty" do
      assert Brain.get("nonexistent key") == []
    end
  end

  describe ".set" do

    test "sets the value for a key" do
      assert Brain.get("people") == ["Jane", "Kate"]
      Brain.set("people", ["José"])
      assert Brain.get("people") == ["José"]
    end
  end

  describe ".delete" do

    test "deletes all items at key" do
      Brain.delete("people")
      assert Brain.get("people") == []
    end
  end

  describe ".add" do

    test "adds an item to a list at the given key" do
      Brain.add("people", "Steve")
      assert Brain.get("people") == ["Jane", "Kate", "Steve"]
    end

    test "creates a list if the key is empty" do
      Brain.add("does not exist", "Leonardo")
      assert Brain.get("does not exist") == ["Leonardo"]
    end
  end

  describe ".remove" do

    test "removes an item from a list at the given key" do
      Brain.remove("people", "Kate")
      assert Brain.get("people") == ["Jane"]
    end

    test "does not error if the item does not exist" do
      Brain.remove("people", "A horse")
    end

    test "does not error if the key is empty" do
      Brain.remove("programmers", "Ada")
    end
  end

  describe ".at_index" do

    test "gets an item from a list by key at a given index" do
      assert Brain.at_index("people", 1) == "Kate"
    end

    test "returns nil with nothing at the index" do
      assert Brain.at_index("people", 999) == nil
    end
  end
end
