defmodule Elix.Responders.GuysTest do
  use Hedwig.RobotCase

  @moduletag start_robot: true, name: "elix", responders: [{Elix.Responders.Guys, []}]

  test "hey guys", %{adapter: adapter, msg: msg} do
    send adapter, {:message, %{msg | text: "hey guys"}}
    assert_receive {:message, %{text: text}}
    assert String.contains?(text, "Terms like *guys* can feel exclusionary. Did you mean **")
    assert String.ends_with?(text, "**?")
  end

  test "guys at beginning", %{adapter: adapter, msg: msg} do
    send adapter, {:message, %{msg | text: "Guys, what do you think about this?"}}
    assert_receive {:message, %{text: text}}
    assert String.contains?(text, "*guys* can feel exclusionary.")
  end

  test "guys as part of a longer word is ignored", %{adapter: adapter, msg: msg} do
    send adapter, {:message, %{msg | text: "maguyser"}}
    refute_receive {:message, %{}}
  end
end
