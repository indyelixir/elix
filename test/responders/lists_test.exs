defmodule Elix.Responders.ListsTest do
  use Hedwig.RobotCase
  import Elix.MessageHelpers
  alias Hedwig.Brain

  @moduletag start_robot: true, name: bot_name(), responders: [{Elix.Responders.Lists, []}]

  setup do
    Brain.set("lists", ["Groceries", "PLIBMTLBHGATY", "Places to Visit"])
    Brain.set("lists:groceries", ["platypus milk"])
    Brain.set("lists:plibmtlbhgaty", [])
    Brain.set("lists:places-to-visit", ["Indianapolis", "The Moon", "Space"])
  end

  describe "Elix.Responders.Lists" do

    test "'show lists' displays all lists", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("show lists")}}

      assert_receive {:message, %{text: text}}
      assert text == """
      1. Groceries
      2. PLIBMTLBHGATY
      3. Places to Visit
      """
    end

    test "'show lists' says when there are no lists", %{adapter: adapter, msg: msg} do
      Brain.delete("lists")
      send adapter, {:message, %{msg | text: to_bot("show lists")}}

      assert_receive {:message, %{text: text}}
      assert text == "There are no lists yet."
    end

    test "'create list' creates a list", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("create list Robot Features")}}

      assert_receive {:message, %{text: text}}
      assert text == """
      1. Groceries
      2. PLIBMTLBHGATY
      3. Places to Visit
      4. Robot Features
      """
    end

    test "'show list' displays contents of a list by name", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("show list Places to Visit")}}

      assert_receive {:message, %{text: text}}
      assert text == """
      **Places to Visit**

      1. Indianapolis
      2. The Moon
      3. Space
      """
    end

    test "'show list' displays contents of a list by number", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("show list 3")}}

      assert_receive {:message, %{text: text}}
      assert text == """
      **Places to Visit**

      1. Indianapolis
      2. The Moon
      3. Space
      """
    end

    test "'show list' replies with error message for nonexistent lists by name", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("show list Nope")}}

      assert_receive {:message, %{text: text}}
      assert text == "Sorry, I couldn’t find that list."
    end

    test "'show list' replies with error message for nonexistent lists by number", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("show list 99")}}

      assert_receive {:message, %{text: text}}
      assert text == "Sorry, I couldn’t find that list."
    end

    test "'delete list' deletes a list by name", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("delete list Places to Visit")}}

      assert_receive {:message, %{text: text}}
      assert text == """
      1. Groceries
      2. PLIBMTLBHGATY
      """
    end

    test "'delete list' deletes a list by number", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("delete list 3")}}

      assert_receive {:message, %{text: text}}
      assert text == """
      1. Groceries
      2. PLIBMTLBHGATY
      """
    end

    test "'delete list' replies with error message for nonexistent lists by name", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("delete list Nope")}}

      assert_receive {:message, %{text: text}}
      assert text == "Sorry, I couldn’t find that list."
    end

    test "'delete list' replies with error message for nonexistent lists by number", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("delete list 99")}}

      assert_receive {:message, %{text: text}}
      assert text == "Sorry, I couldn’t find that list."
    end

    test "'clear list' removes all items from a list by name", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("clear list PLIBMTLBHGATY")}}

      assert_receive {:message, %{text: text}}
      assert text == """
      **PLIBMTLBHGATY**

      """
    end

    test "'clear list' removes all items from a list by number", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("clear list 2")}}

      assert_receive {:message, %{text: text}}
      assert text == """
      **PLIBMTLBHGATY**

      """
    end

    test "'clear list' replies with error message for nonexistent lists by name", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("clear list Nope")}}

      assert_receive {:message, %{text: text}}
      assert text == "Sorry, I couldn’t find that list."
    end

    test "'clear list' replies with error message for nonexistent lists by number", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("clear list 99")}}

      assert_receive {:message, %{text: text}}
      assert text == "Sorry, I couldn’t find that list."
    end

    test "'add item to list' adds an item to a list by name", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("add jazzberries to Groceries")}}

      assert_receive {:message, %{text: text}}
      assert text == """
      **Groceries**

      1. platypus milk
      2. jazzberries
      """
    end

    test "'add item to list' adds an item to a list by number", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("add jazzberries to 1")}}

      assert_receive {:message, %{text: text}}
      assert text == """
      **Groceries**

      1. platypus milk
      2. jazzberries
      """
    end

    test "'add item to list' replies with error message for nonexistent lists by name", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("add something to Nope")}}

      assert_receive {:message, %{text: text}}
      assert text == "Sorry, I couldn’t find that list."
    end

    test "'add item to list' replies with error message for nonexistent lists by number", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("add something to 99")}}

      assert_receive {:message, %{text: text}}
      assert text == "Sorry, I couldn’t find that list."
    end

    test "'delete item from list' removes an item from a list by name", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("delete The Moon from Places to Visit")}}

      assert_receive {:message, %{text: text}}
      assert text == """
      **Places to Visit**

      1. Indianapolis
      2. Space
      """
    end

    test "'delete item from list' removes an item from a list by number", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("delete 2 from 3")}}

      assert_receive {:message, %{text: text}}
      assert text == """
      **Places to Visit**

      1. Indianapolis
      2. Space
      """
    end

    test "'delete item from list' replies with error message for nonexistent lists by name", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("delete something from Nope")}}

      assert_receive {:message, %{text: text}}
      assert text == "Sorry, I couldn’t find that list."
    end

    test "'delete item from list' replies with error message for nonexistent lists by number", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("delete something from 99")}}

      assert_receive {:message, %{text: text}}
      assert text == "Sorry, I couldn’t find that list."
    end

    test "'delete item from list' replies with error message for nonexistent items by name", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("delete nowhere from Places to Visit")}}

      assert_receive {:message, %{text: text}}
      assert text == "Sorry, I couldn’t find that item."
    end

    test "'delete item from list' replies with error message for nonexistent items by number", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("delete 99 from 3")}}

      assert_receive {:message, %{text: text}}
      assert text == "Sorry, I couldn’t find that item."
    end
  end
end
