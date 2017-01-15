defmodule Elix.Responders.RemindMeTest do
  use Hedwig.RobotCase
  import Elix.MessageHelpers

  @moduletag start_robot: true, name: bot_name(), responders: [{Elix.Responders.RemindMe, []}]

  describe "Elix.Responders.RemindMe" do

    test "responds with the reminder", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("remind me to eat in 15 seconds")}}

      assert_receive {:message, %{text: text}}
      assert text == to_user "Okay, I’ll remind you to eat in 15 seconds."
    end

    test "is helpful about parse errors", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("remind me to explode in WAIT NO NEVER")}}

      assert_receive {:message, %{text: text}}
      assert text |> String.starts_with?(to_user("Sorry, I don’t understand"))
    end
  end
end
