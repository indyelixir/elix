defmodule Elix.ListTest do
  use ExUnit.Case, async: true
  alias Hedwig.Brain

  doctest Elix.List

  setup do
    Brain.set("lists", ["Groceries", "PLIBMTLBHGATY", "Places to Visit"])
    Brain.set("lists:groceries", ["platypus milk"])
    Brain.set("lists:plibmtlbhgaty", [])
    Brain.set("lists:places-to-visit", ["Indianapolis", "The Moon", "Space"])
  end
end
