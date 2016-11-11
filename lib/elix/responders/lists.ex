defmodule Elix.Responders.Lists do
  @moduledoc """
  Commands to create, update, and delete one-dimensional lists and their items.
  """

  use Hedwig.Responder
  alias Hedwig.Message
  alias Elix.List

  @usage """
  show lists - Displays all lists
  """
  respond ~r/show lists\Z/i, msg do
    reply(msg, render_items(List.all_names))
  end

  @usage """
  create list <name> - Creates a new list with name
  """
  respond ~r/create list (.+)/i, %Message{matches: %{1 => list_name}} = msg do
    %List{} = List.create(list_name)

    reply(msg, render_items(List.all_names))
  end

  @usage """
  show list <list> - Displays the contents of a list by name or number
  """
  respond ~r/show list (.+)/i, %Message{matches: %{1 => list_id}} = msg do
    response = with_list(list_id, &render_list(&1))

    reply(msg, response)
  end

  @usage """
  delete list <list> - Deletes a list by name or number
  """
  respond ~r/delete list (.+)/i, %Message{matches: %{1 => list_id}} = msg do
    response =
      with_list(list_id, fn (list) ->
        :ok = List.delete(list)
        render_items(List.all_names)
      end)

    reply(msg, response)
  end

  @usage """
  clear list <list> - Deletes all items from a list by name or number
  """
  respond ~r/clear list (.+)/i, %Message{matches: %{1 => list_id}} = msg do
    response =
      with_list(list_id, fn (list) ->
        list
        |> List.clear_items
        |> render_list
      end)

    reply(msg, response)
  end

  @usage """
  add <item> to <list> - Adds an item to a list by name or number
  """
  respond ~r/add (.+) to (.+)/i, %Message{matches: %{1 => item_name, 2 => list_id}} = msg do
    response =
      with_list(list_id, fn (list) ->
        list
        |> List.add_item(item_name)
        |> render_list()
      end)

    reply(msg, response)
  end

  @usage """
  delete <item> from <name> - Deletes an item from a list by name or number
  """
  respond ~r/delete (.+) from (.+)/i, %Message{matches: %{1 => item_id, 2 => list_id}} = msg do
    response =
      with_list_and_item(list_id, item_id, fn (list, item) ->
        list
        |> List.delete_item(item)
        |> render_list()
      end)

    reply(msg, response)
  end

  defp with_list(list_identifier, function) do
    with {:ok, list} <- parse_list_identifier(list_identifier) do
      function.(list)
    else
      {:error, :list_not_found} -> "Sorry, I couldn’t find that list."
    end
  end

  defp with_list_and_item(list_identifier, item_identifier, function) do
    with {:ok, list} <- parse_list_identifier(list_identifier),
         {:ok, item} <- parse_item_identifier(item_identifier, list.name) do

         function.(list, item)
    else
      {:error, :list_not_found} -> "Sorry, I couldn’t find that list."
      {:error, :item_not_found} -> "Sorry, I couldn’t find that item."
    end
  end

  defp parse_list_identifier(list_id) do
    try do
      list_id |> String.to_integer |> List.get_by_number
    rescue
      _e in ArgumentError -> list_id |> List.get_by_name
    end
  end

  defp parse_item_identifier(item_id, list_name) do
    try do
      item_id |> String.to_integer |> List.get_item_name(list_name)
    rescue
      _e in ArgumentError -> item_id |> List.get_item_by_name(list_name)
    end
  end

  defp render_list(%List{name: name, items: items}) do
    "**#{name}**\n\n#{render_items(items)}"
  end

  defp render_items(items) when is_list(items) do
    items
    |> Enum.with_index(1)
    |> Enum.map(fn({item, index}) -> "#{index}. #{item}\n" end)
    |> Enum.join
  end
end
