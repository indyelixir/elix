defmodule Elix.ListTest do
  use ExUnit.Case, async: true
  alias Elix.Brain

  doctest Elix.List

  setup do
    [{:ok, _} = Brain.start_link(
      %{
        "lists" => ["Groceries", "PLIBMTLBHGATY", "Places to Visit"],
        "lists:groceries" => ["platypus milk"],
        "lists:plibmtlbhgaty" => [],
        "lists:places-to-visit" => ["Indianapolis", "The Moon", "Space"]
      }
    )]
  end
end
