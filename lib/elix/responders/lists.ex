defmodule Elix.Responders.Lists do
  @moduledoc """
  Commands to create, update, and delete
  one-dimensional lists and their items.
  """

  use Hedwig.Responder
  alias Elix.List

  @usage """
  show lists - Displays all lists
  """
  respond ~r/show lists\Z/i, msg do
    reply(msg, render_items(List.all))
  end

  @usage """
  create list <name> - Creates a new list with name
  """
  respond ~r/create list (.+)/i, msg do
    List.create(msg.matches[1])
    reply(msg, render_items(List.all))
  end

  @usage """
  show list <name> - Displays the contents of a list by name
  """
  respond ~r/show list (.+)/i, msg do
    list_name = msg.matches[1]

    reply(msg, render_list(list_name))
  end

  @usage """
  delete list <name> - Deletes a list by name
  """
  respond ~r/delete list (.+)/i, msg do
    List.delete(msg.matches[1])

    reply(msg, render_items(List.all))
  end

  @usage """
  clear list <name> - Deletes all items from a list by name
  """
  respond ~r/clear list (.+)/i, msg do
    list_name = msg.matches[1]
    List.clear_items(list_name)

    reply(msg, render_list(list_name))
  end

  @usage """
  add <item> to <name> - Adds an item to a list by name
  """
  respond ~r/add (.+) to (.+)/i, msg do
    item_name = msg.matches[1]
    list_name = msg.matches[2]
    List.add_item(list_name, item_name)

    reply(msg, render_list(list_name))
  end

  @usage """
  delete <item> from <name> - Deletes an item from a list by name
  """
  respond ~r/delete (.+) from (.+)/i, msg do
    item_name = msg.matches[1]
    list_name = msg.matches[2]
    List.delete_item(list_name, item_name)

    reply(msg, render_list(list_name))
  end

  defp render_items(list) when is_list(list) do
    list
    |> Enum.with_index(1)
    |> Enum.map(fn({item, index}) -> "#{index}. #{item}\n" end)
    |> Enum.join
  end

  defp render_list(list_name) when is_binary(list_name) do
    "**#{list_name}**\n\n#{render_items(List.get_items(list_name))}"
  end
end
