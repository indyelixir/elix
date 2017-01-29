defmodule Elix.BrainTest do
  use ExUnit.Case, async: true
  alias Elix.Brain

  setup do
    Redix.command!(:redis, ["FLUSHDB"])
    Brain.set("people", ["Jane", "Kate"])
    :ok
  end

  describe ".set" do

    test "sets the value for a key" do
      assert Brain.all("people") == ["Jane", "Kate"]
      Brain.set("people", ["José"])
      assert Brain.all("people") == ["José"]
    end

    test "handles complex terms" do
      assert Brain.all("people") == ["Jane", "Kate"]
      term = %{first_name: "José", last_name: "Valim"}
      Brain.set("people", [term])
      assert Brain.all("people") == [term]
    end
  end

  describe ".all" do

    test "returns the value at a key" do
      assert Brain.all("people") == ["Jane", "Kate"]
    end

    test "returns an empty list when key is empty" do
      assert Brain.all("nonexistent key") == []
    end
  end

  describe ".delete" do

    test "deletes all items at key" do
      Brain.delete("people")
      assert Brain.all("people") == []
    end
  end

  describe ".add" do

    test "adds an item to a list at the given key" do
      Brain.add("people", "Steve")
      assert Brain.all("people") == ["Jane", "Kate", "Steve"]
    end

    test "creates a list if the key is empty" do
      Brain.add("does not exist", "Leonardo")
      assert Brain.all("does not exist") == ["Leonardo"]
    end

    test "adds complex terms to the list" do
      term = %{first_name: "José", last_name: "Valim"}
      Brain.add("people", term)
      assert Brain.all("people") == ["Jane", "Kate", term]
    end
  end

  describe ".remove" do

    test "removes an item from a list at the given key" do
      Brain.remove("people", "Kate")
      assert Brain.all("people") == ["Jane"]
    end

    test "does not error if the item does not exist" do
      Brain.remove("people", "A horse")
    end

    test "does not error if the key is empty" do
      Brain.remove("programmers", "Ada")
    end

    test "removes complex terms to the list" do
      term = %{first_name: "José", last_name: "Valim"}
      Brain.add("people", term)
      Brain.remove("people", term)
      assert Brain.all("people") == ["Jane", "Kate"]
    end
  end

  describe ".at_index" do

    test "gets an item from a list by key at a given index" do
      assert Brain.at_index("people", 1) == "Kate"
    end

    test "returns nil with nothing at the index" do
      assert Brain.at_index("people", 999) == nil
    end

    test "gets a complex term by index" do
      term = %{first_name: "José", last_name: "Valim"}
      Brain.add("people", term)
      assert Brain.at_index("people", 2) == term
    end
  end
end
