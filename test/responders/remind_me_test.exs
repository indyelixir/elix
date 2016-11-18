defmodule Elix.Responders.RemindMeTest do
  use Hedwig.RobotCase
  import Elix.MessageHelpers

  describe "Elix.Responders.RemindMe" do

    @tag start_robot: true, name: bot_name, responders: [{Elix.Responders.RemindMe, []}]
    test "responds with the reminder", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("remind me to eat in 15 seconds")}}

      assert_receive {:message, %{text: text}}
      assert text == to_user "Okay, I’ll remind you to eat in 15 seconds."
    end
  end
end
