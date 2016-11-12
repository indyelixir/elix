defmodule Elix.Responders.RemindMeTest do
  use Hedwig.RobotCase

  @user_name "testuser"
  @bot_name "Elix"

  describe "Elix.Responders.RemindMe" do

    @tag start_robot: true, name: "elix", responders: [{Elix.Responders.RemindMe, []}]
    test "responds with the reminder", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: to_bot("remind me to eat in 15 minutes")}}

      assert_receive {:message, %{text: text}}
      assert text == to_user "Okay, I’ll remind you to eat in 15 minutes"
    end
  end

  # TODO: DRY me
  defp to_bot(text) when is_binary(text) do
    @bot_name <> " " <> text
  end

  defp to_user(string) when is_binary(string) do
    @user_name <> ": " <> string
  end
end
