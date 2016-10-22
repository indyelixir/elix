defmodule Elix.Responders.ListsTest do
  use Hedwig.RobotCase

  @user_name "testuser"
  @bot_name "Elix"

  describe "Elix.Responders.Lists" do

    @tag start_robot: true, name: @bot_name, responders: [{Elix.Responders.Lists, []}]
    test "'show lists' displays all lists", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("show lists")}}

      assert_receive {:message, %{text: text}}
      assert text == to_user """
      1. Groceries
      2. PLIBMTLBHGATY
      3. Places to Visit
      """
    end

    @tag start_robot: true, name: @bot_name, responders: [{Elix.Responders.Lists, []}]
    test "'create list' creates a list", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("create list Places to Visit")}}

      assert_receive {:message, %{text: text}}
      assert text == to_user """
      1. Groceries
      2. PLIBMTLBHGATY
      3. Places to Visit
      """
    end

    @tag start_robot: true, name: @bot_name, responders: [{Elix.Responders.Lists, []}]
    test "'show list' displays contents of a list", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("show list Places to Visit")}}

      assert_receive {:message, %{text: text}}
      assert text == to_user """
      **Places to Visit**

      1. Indianapolis
      2. The Moon
      3. Space
      """
    end

    @tag start_robot: true, name: @bot_name, responders: [{Elix.Responders.Lists, []}]
    test "'show list' displays contents of a list by number", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("show list 3")}}

      assert_receive {:message, %{text: text}}
      assert text == to_user """
      **Places to Visit**

      1. Indianapolis
      2. The Moon
      3. Space
      """
    end

    @tag start_robot: true, name: @bot_name, responders: [{Elix.Responders.Lists, []}]
    test "'delete list' deletes a list by name", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("delete list Places to Visit")}}

      assert_receive {:message, %{text: text}}
      assert text == to_user """
      1. Groceries
      2. PLIBMTLBHGATY
      3. Places to Visit
      """
    end

    @tag start_robot: true, name: @bot_name, responders: [{Elix.Responders.Lists, []}]
    test "'delete list' deletes a list by number", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("delete list 3")}}

      assert_receive {:message, %{text: text}}
      assert text == to_user """
      1. Groceries
      2. PLIBMTLBHGATY
      3. Places to Visit
      """
    end

    @tag start_robot: true, name: @bot_name, responders: [{Elix.Responders.Lists, []}]
    test "'clear list' removes all items from a list by name", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("clear list PLIBMTLBHGATY")}}

      assert_receive {:message, %{text: text}}
      assert text == to_user """
      **PLIBMTLBHGATY**

      """
    end

    @tag start_robot: true, name: @bot_name, responders: [{Elix.Responders.Lists, []}]
    test "'clear list' removes all items from a list by number", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("clear list 2")}}

      assert_receive {:message, %{text: text}}
      assert text == to_user """
      **PLIBMTLBHGATY**

      """
    end

    @tag start_robot: true, name: @bot_name, responders: [{Elix.Responders.Lists, []}]
    test "'add item to list' adds an item to a list by name", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("add platypus milk to Groceries")}}

      assert_receive {:message, %{text: text}}
      assert text == to_user """
      **Groceries**

      1. platypus milk
      """
    end

    @tag start_robot: true, name: @bot_name, responders: [{Elix.Responders.Lists, []}]
    test "'add item to list' adds an item to a list by number", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("add platypus milk to 1")}}

      assert_receive {:message, %{text: text}}
      assert text == to_user """
      **Groceries**

      1. platypus milk
      """
    end

    @tag start_robot: true, name: @bot_name, responders: [{Elix.Responders.Lists, []}]
    test "'delete item from list' removes an item from a list by name", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("delete The Moon from Places to Visit")}}

      assert_receive {:message, %{text: text}}
      assert text == to_user """
      **Places to Visit**

      1. Indianapolis
      2. The Moon
      3. Space
      """
    end

    @tag start_robot: true, name: @bot_name, responders: [{Elix.Responders.Lists, []}]
    test "'delete item from list' removes an item from a list by number", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("delete 2 from 3")}}

      assert_receive {:message, %{text: text}}
      assert text == to_user """
      **Places to Visit**

      1. Indianapolis
      2. The Moon
      3. Space
      """
    end
  end

  defp to_bot(text) when is_binary(text) do
    @bot_name <> " " <> text
  end

  defp to_user(string) when is_binary(string) do
    @user_name <> ": " <> string
  end
end
