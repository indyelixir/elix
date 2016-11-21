defmodule Elix.MessageHelpers do

  @bot_name "Elix"
  @user_name "testuser"

  def bot_name do
    @bot_name
  end

  def user_name do
    @user_name
  end

  def to_bot(message) when is_binary(message) do
    @bot_name <> " " <> message
  end

  def to_user(message) when is_binary(message) do
    @user_name <> ": " <> message
  end
end
