defmodule Elix.Responders.GifMeTest do
  use Hedwig.RobotCase

  describe "Elix.Responders.GifMe" do

    @tag start_robot: true, name: "elix", responders: [{Elix.Responders.GifMe, []}]
    test "responds with a GIF url", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: "gif me success"}}

      assert_receive {:message, %{text: text}}
      assert String.ends_with?(text, "http://gifs.test/success.gif")
    end

    @tag start_robot: true, name: "elix", responders: [{Elix.Responders.GifMe, []}]
    test "handles HTTP errors", %{adapter: adapter, msg: msg} do
      send adapter, {:message, %{msg | text: "gif me error"}}

      assert_receive {:message, %{text: text}}
      assert String.ends_with?(text, "I’m sorry, Giphy isn’t talking to me right now.")
    end
  end
end
