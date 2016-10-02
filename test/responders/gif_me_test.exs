defmodule Elix.Responders.GifMeTest do
  use Hedwig.RobotCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @tag start_robot: true, name: "elix", responders: [{Elix.Responders.GifMe, []}]
  test "gif me - responds with a GIF url", %{adapter: adapter, msg: msg} do
    use_cassette "giphy_search_steve" do
      send adapter, {:message, %{msg | text: "gif me steve"}}
      assert_receive {:message, %{text: text}}
      assert String.ends_with?(text, ".gif")
    end
  end
end
