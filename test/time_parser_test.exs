defmodule Elix.TimeParserTest do
  use ExUnit.Case, async: true

  describe "Elix.TimeParser.from_now" do

    test "parses seconds" do
      assert Elix.TimeParser.from_now("1 second") == 1
      assert Elix.TimeParser.from_now("10 seconds") == 10
      assert Elix.TimeParser.from_now("11s") == 11
      assert Elix.TimeParser.from_now("15 s") == 15
    end

    test "parses minutes" do
      assert Elix.TimeParser.from_now("1 minute") == 1 * 60
      assert Elix.TimeParser.from_now("3 minutes") == 3 * 60
      assert Elix.TimeParser.from_now("5 min") == 5 * 60
      assert Elix.TimeParser.from_now("6min") == 6 * 60
      assert Elix.TimeParser.from_now("7 mins") == 7 * 60
      assert Elix.TimeParser.from_now("8mins") == 8 * 60
      assert Elix.TimeParser.from_now("12m") == 12 * 60
      assert Elix.TimeParser.from_now("14 m") == 14 * 60
    end

    test "parses hours" do
      assert Elix.TimeParser.from_now("1 hour") == 1 * 60 * 60
      assert Elix.TimeParser.from_now("3 hours") == 3 * 60 * 60
      assert Elix.TimeParser.from_now("5 hr") == 5 * 60 * 60
      assert Elix.TimeParser.from_now("6hr") == 6 * 60 * 60
      assert Elix.TimeParser.from_now("7 hrs") == 7 * 60 * 60
      assert Elix.TimeParser.from_now("8hrs") == 8 * 60 * 60
      assert Elix.TimeParser.from_now("12h") == 12 * 60 * 60
      assert Elix.TimeParser.from_now("14 h") == 14 * 60 * 60
    end

    test "parses days" do
      assert Elix.TimeParser.from_now("1 day") == 1 * 60 * 60 * 24
      assert Elix.TimeParser.from_now("3 days") == 3 * 60 * 60 * 24
      assert Elix.TimeParser.from_now("4day") == 4 * 60 * 60 * 24
      assert Elix.TimeParser.from_now("5days") == 5 * 60 * 60 * 24
      assert Elix.TimeParser.from_now("12d") == 12 * 60 * 60 * 24
      assert Elix.TimeParser.from_now("14 d") == 14 * 60 * 60 * 24
    end

    test "parses weeks" do
      assert Elix.TimeParser.from_now("1 week") == 1 * 60 * 60 * 24 * 7
      assert Elix.TimeParser.from_now("3 weeks") == 3 * 60 * 60 * 24 * 7
      assert Elix.TimeParser.from_now("4wk") == 4 * 60 * 60 * 24 * 7
      assert Elix.TimeParser.from_now("5 wk") == 5 * 60 * 60 * 24 * 7
      assert Elix.TimeParser.from_now("6wks") == 6 * 60 * 60 * 24 * 7
      assert Elix.TimeParser.from_now("7 wks") == 7 * 60 * 60 * 24 * 7
      assert Elix.TimeParser.from_now("12w") == 12 * 60 * 60 * 24 * 7
      assert Elix.TimeParser.from_now("14 w") == 14 * 60 * 60 * 24 * 7
    end

    test "returns :error for unparsable times" do
      assert Elix.TimeParser.from_now("Forever") == :error
    end
  end
end
