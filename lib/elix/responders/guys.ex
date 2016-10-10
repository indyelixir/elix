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
    unless from_self?(msg) do
      response = "Terms like *guys* can feel exclusionary. Did you mean **" <> random(@forms_of_address) <> "**?"
      reply(msg, response)
    end
  end

  # An infinite loop happens when Elix hears itself use the word "guys",
  # so we need Elix not to reply to itself. The `ignore_from_self?` config
  # option appears to have been removed so we reproduce it here. With the
  # Console adapter `user` is a string, but with the Flowdock adapter `user`
  # is a `Hedwig.User` struct, hence the pattern matching.
  defp from_self?(%Hedwig.Message{user: %Hedwig.User{name: "Elix"}}), do: true
  defp from_self?(%Hedwig.Message{user: "Elix"}), do: true
  defp from_self?(%Hedwig.Message{}), do: false
end
