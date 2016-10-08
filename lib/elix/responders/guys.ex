defmodule Elix.Responders.Guys do
  @moduledoc """
  Encourages the use of gender-neutral forms of address
  """

  use Hedwig.Responder

  @forms_of_address [
    "all y’all",
    "crew",
    "elixirists",
    "everybody",
    "everyone",
    "folks",
    "friends",
    "mere mortals",
    "non-robots",
    "peeps",
    "y’all"
  ]

  @usage """
  (hey|you|those) guys - Replies with a gentle reminder to use gender-neutral forms of address
  """

  hear ~r/\bguys\b/i, msg do
    reply msg, "Terms like *guys* can feel exclusionary. Did you mean **" <> random(@forms_of_address) <> "**?"
  end
end
