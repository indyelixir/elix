defmodule Elix.Responders.Lists do
  @moduledoc """
  Commands to create, update, and delete
  one-dimensional lists and their items.
  """

  use Hedwig.Responder
  alias Elix.Lists

  @usage """
  show lists <term> - Displays all lists
  """
  respond ~r/show lists\Z/i, msg do
    reply(msg, render_items(Lists.all))
  end

  @usage """
  create list <name> - Creates a new list with name
  """
  respond ~r/create list (.+)/i, msg do
    Lists.create(msg.matches[1])
    reply(msg, render_items(Lists.all))
  end

  @usage """
  delete list <name> - Deletes a list by name
  """
  respond ~r/delete list (.+)/i, msg do
    Lists.delete(msg.matches[1])
    reply(msg, render_items(Lists.all))
  end

  def render_items(list) when is_list(list) do
    list
    |> Enum.with_index(1)
    |> Enum.map(fn({item, index}) -> "#{index}. #{item}\n" end)
    |> Enum.join
  end
end
