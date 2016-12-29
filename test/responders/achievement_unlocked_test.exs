defmodule Elix.Responders.AchievementUnlockedTest do
  use Hedwig.RobotCase
  import Elix.MessageHelpers

  @moduletag start_robot: true, name: "elix", responders: [{Elix.Responders.AchievementUnlocked, []}]

  describe "Elix.Responders.AchievementUnlocked" do

    test "responds with a GIF url", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: "@Steve unlocked achievement Passing Specs!"}}

      assert_receive {:message, %{text: text}}
      assert text == to_user(
        "http://achievement-unlocked.herokuapp.com/xbox/Passing%20Specs!?header=ACHIEVEMENT%2520UNLOCKED"
      )
    end
  end
end
