defmodule Elix.RedisStore.RedisStoreTest do
  use ExUnit.Case, async: false
  alias Elix.Brain.RedisStore

  setup context do
    RedisStore.start_link
    RedisStore.delete_all
    if context[:with_people] do
      RedisStore.set("people", ["Jane", "Kate"])
    end
    :ok
  end

  describe ".set" do

    @tag :with_people
    test "sets the value for a key, overwriting existing values" do
      assert RedisStore.get("people") == ["Jane", "Kate"]
      RedisStore.set("people", ["José"])
      assert RedisStore.get("people") == ["José"]
    end

    test "handles complex terms" do
      term = %{first_name: "José", last_name: "Valim"}
      RedisStore.set("people", [term])
      assert RedisStore.get("people") == [term]
    end
  end

  describe ".get" do

    @tag :with_people
    test "returns the value at a key" do
      assert RedisStore.get("people") == ["Jane", "Kate"]
    end

    test "returns an empty list when key is empty" do
      assert RedisStore.get("nonexistent key") == []
    end
  end

  describe ".delete" do

    @tag :with_people
    test "deletes all items at key" do
      RedisStore.delete("people")
      assert RedisStore.get("people") == []
    end
  end

  describe ".add" do

    @tag :with_people
    test "adds an item to a list at the given key" do
      RedisStore.add("people", "Steve")
      assert RedisStore.get("people") == ["Jane", "Kate", "Steve"]
    end

    test "creates a list if the key is empty" do
      RedisStore.add("does not exist", "Leonardo")
      assert RedisStore.get("does not exist") == ["Leonardo"]
    end

    test "adds complex terms to the list" do
      term = %{first_name: "José", last_name: "Valim"}
      RedisStore.add("people", term)
      assert RedisStore.get("people") == [term]
    end
  end

  describe ".remove" do

    @tag :with_people
    test "removes an item from a list at the given key" do
      RedisStore.remove("people", "Kate")
      assert RedisStore.get("people") == ["Jane"]
    end

    @tag :with_people
    test "does not error if the item does not exist" do
      RedisStore.remove("people", "A horse")
    end

    test "does not error if the key is empty" do
      RedisStore.remove("programmers", "Ada")
    end

    test "removes complex terms from the list" do
      term = %{first_name: "José", last_name: "Valim"}
      RedisStore.add("people", term)
      assert RedisStore.get("people") == [term]
      RedisStore.remove("people", term)
      assert RedisStore.get("people") == []
    end
  end

  describe ".at_index" do

    @tag :with_people
    test "gets an item from a list by key at a given index" do
      assert RedisStore.at_index("people", 1) == "Kate"
    end

    @tag :with_people
    test "returns nil with nothing at the index" do
      assert RedisStore.at_index("people", 999) == nil
    end

    @tag :with_people
    test "gets a complex term by index" do
      term = %{first_name: "José", last_name: "Valim"}
      RedisStore.add("people", term)
      assert RedisStore.at_index("people", 2) == term
    end
  end
end
