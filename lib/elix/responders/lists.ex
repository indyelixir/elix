defmodule Elix.Responders.Lists do
  @moduledoc """
  Commands to create, update, and delete one-dimensional lists and their items.
  """

  use Hedwig.Responder
  alias Hedwig.Message
  alias Elix.Lists

  @usage """
  show lists - Displays all lists
  """
  respond ~r/show lists\Z/i, msg do
    reply(msg, render_items(Lists.all))
  end

  @usage """
  create list <name> - Creates a new list with name
  """
  respond ~r/create list (.+)/i, %Message{matches: %{1 => list_name}} = msg do
    Lists.create(list_name)
    reply(msg, render_items(Lists.all))
  end

  @usage """
  show list <list> - Displays the contents of a list by name or number
  """
  respond ~r/show list (.+)/i, %Message{matches: %{1 => list_id}} = msg do
    response =
      case parse_list_identifier(list_id) do
        :list_not_found -> "Sorry, I couldn’t find that list."
        list_name  -> render_list(list_name)
      end

    reply(msg, response)
  end

  @usage """
  delete list <list> - Deletes a list by name or number
  """
  respond ~r/delete list (.+)/i, %Message{matches: %{1 => list_id}} = msg do
    response =
      case parse_list_identifier(list_id) do
        :list_not_found ->
            "Sorry, I couldn’t find that list."
        list_name  ->
          Lists.delete(list_name)
          render_items(Lists.all)
      end

    reply(msg, response)
  end

  @usage """
  clear list <list> - Deletes all items from a list by name or number
  """
  respond ~r/clear list (.+)/i, %Message{matches: %{1 => list_id}} = msg do
    response =
      case parse_list_identifier(list_id) do
        :list_not_found ->
            "Sorry, I couldn’t find that list."
        list_name  ->
          Lists.clear_items(list_name)
          render_list(list_name)
      end

    reply(msg, response)
  end

  @usage """
  add <item> to <list> - Adds an item to a list by name or number
  """
  respond ~r/add (.+) to (.+)/i, %Message{matches: %{1 => item_name, 2 => list_id}} = msg do
    response =
      case parse_list_identifier(list_id) do
        :list_not_found ->
            "Sorry, I couldn’t find that list."
        list_name  ->
          Lists.add_item(list_name, item_name)
          render_list(list_name)
      end

    reply(msg, response)
  end

  @usage """
  delete <item> from <name> - Deletes an item from a list by name or number
  """
  respond ~r/delete (.+) from (.+)/i, %Message{matches: %{1 => item_id, 2 => list_id}} = msg do
    response =
      case parse_list_identifier(list_id) do
        :list_not_found ->
            "Sorry, I couldn’t find that list."
        list_name  ->
          case parse_item_identifier(item_id, list_name) do
            :item_not_found ->
              "Sorry, I couldn’t find that item."
            item_name ->
              Lists.delete_item(list_name, item_name)
              render_list(list_name)
          end
      end

    reply(msg, response)
  end

  defp parse_list_identifier(list_id) do
    if numeric_string?(list_id) do
      list_id |> String.to_integer |> Lists.get_name
    else
      list_id |> Lists.get_by_name
    end
  end

  defp parse_item_identifier(item_id, list_name) do
    if numeric_string?(item_id) do
      item_id |> String.to_integer |> Lists.get_item_name(list_name)
    else
      item_id |> Lists.get_item_by_name(list_name)
    end
  end

  defp numeric_string?(string) do
    Regex.match?(~r/\A\d+\Z/, string)
  end

  defp render_items(list) when is_list(list) do
    list
    |> Enum.with_index(1)
    |> Enum.map(fn({item, index}) -> "#{index}. #{item}\n" end)
    |> Enum.join
  end

  defp render_list(list_name) when is_binary(list_name) do
    "**#{list_name}**\n\n#{render_items(Lists.get_items(list_name))}"
  end
end
