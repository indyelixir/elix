defmodule Elix.TimeParserTest do
  use ExUnit.Case, async: true

  describe "Elix.TimeParser.from_now" do

    test "parses seconds" do
      assert Elix.TimeParser.from_now("1 second")   == {:ok, 1}
      assert Elix.TimeParser.from_now("10 seconds") == {:ok, 10}
      assert Elix.TimeParser.from_now("11s")        == {:ok, 11}
      assert Elix.TimeParser.from_now("15 s")       == {:ok, 15}
    end

    test "parses minutes" do
      assert Elix.TimeParser.from_now("1 minute")  == {:ok, minutes(1)}
      assert Elix.TimeParser.from_now("3 minutes") == {:ok, minutes(3)}
      assert Elix.TimeParser.from_now("5 min")     == {:ok, minutes(5)}
      assert Elix.TimeParser.from_now("6min")      == {:ok, minutes(6)}
      assert Elix.TimeParser.from_now("7 mins")    == {:ok, minutes(7)}
      assert Elix.TimeParser.from_now("8mins")     == {:ok, minutes(8)}
      assert Elix.TimeParser.from_now("12m")       == {:ok, minutes(12)}
      assert Elix.TimeParser.from_now("14 m")      == {:ok, minutes(14)}
    end

    test "parses hours" do
      assert Elix.TimeParser.from_now("1 hour")  == {:ok, hours(1)}
      assert Elix.TimeParser.from_now("3 hours") == {:ok, hours(3)}
      assert Elix.TimeParser.from_now("5 hr")    == {:ok, hours(5)}
      assert Elix.TimeParser.from_now("6hr")     == {:ok, hours(6)}
      assert Elix.TimeParser.from_now("7 hrs")   == {:ok, hours(7)}
      assert Elix.TimeParser.from_now("8hrs")    == {:ok, hours(8)}
      assert Elix.TimeParser.from_now("12h")     == {:ok, hours(12)}
      assert Elix.TimeParser.from_now("14 h")    == {:ok, hours(14)}
    end

    test "parses days" do
      assert Elix.TimeParser.from_now("1 day")  == {:ok, days(1)}
      assert Elix.TimeParser.from_now("3 days") == {:ok, days(3)}
      assert Elix.TimeParser.from_now("4day")   == {:ok, days(4)}
      assert Elix.TimeParser.from_now("5days")  == {:ok, days(5)}
      assert Elix.TimeParser.from_now("12d")    == {:ok, days(12)}
      assert Elix.TimeParser.from_now("14 d")   == {:ok, days(14)}
    end

    test "parses weeks" do
      assert Elix.TimeParser.from_now("1 week")  == {:ok, weeks(1)}
      assert Elix.TimeParser.from_now("3 weeks") == {:ok, weeks(3)}
      assert Elix.TimeParser.from_now("4wk")     == {:ok, weeks(4)}
      assert Elix.TimeParser.from_now("5 wk")    == {:ok, weeks(5)}
      assert Elix.TimeParser.from_now("6wks")    == {:ok, weeks(6)}
      assert Elix.TimeParser.from_now("7 wks")   == {:ok, weeks(7)}
      assert Elix.TimeParser.from_now("12w")     == {:ok, weeks(12)}
      assert Elix.TimeParser.from_now("14 w")    == {:ok, weeks(14)}
    end

    test "returns :error for unparsable times" do
      assert Elix.TimeParser.from_now("Forever") == {:error, :parse_error}
    end
  end

  defp minutes(count) do
    count * 60
  end

  defp hours(count) do
    minutes(count) * 60
  end

  defp days(count) do
    hours(count) * 24
  end

  defp weeks(count) do
    days(count) * 7
  end
end
