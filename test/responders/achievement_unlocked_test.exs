defmodule Elix.Responders.AchievementUnlockedTest do
  use Hedwig.RobotCase
  import Elix.MessageHelpers

  @moduletag start_robot: true, name: "elix", responders: [{Elix.Responders.AchievementUnlocked, []}]

  describe "Elix.Responders.AchievementUnlocked" do

    test "responds with a GIF url", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: "@Steve unlocked achievement Passing Specs!"}}

      assert_receive {:message, %{text: text}}
      assert text == to_user(
        "\n\nhttp://achievement-unlocked.herokuapp.com/xbox/Passing%20Specs!.jpg?email=xbox%40indyelixir.org&header=ACHIEVEMENT%2520UNLOCKED"
      )
    end

    test "accepts the present tense", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: "@Steve unlocks achievement Passing Specs!"}}

      assert_receive {:message, %{text: text}}
      assert text == to_user(
        "\n\nhttp://achievement-unlocked.herokuapp.com/xbox/Passing%20Specs!.jpg?email=xbox%40indyelixir.org&header=ACHIEVEMENT%2520UNLOCKED"
      )
    end

    test "accepts the imperative tense", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: "@Steve unlock achievement Passing Specs!"}}

      assert_receive {:message, %{text: text}}
      assert text == to_user(
        "\n\nhttp://achievement-unlocked.herokuapp.com/xbox/Passing%20Specs!.jpg?email=xbox%40indyelixir.org&header=ACHIEVEMENT%2520UNLOCKED"
      )
    end
  end
end
