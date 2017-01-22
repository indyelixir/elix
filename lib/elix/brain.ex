defmodule Elix.Brain do
  @moduledoc """
  A general-purpose key-value storage mechanism.
  """

  alias Elix.Brain.ProcessStore

  @behaviour Elix.Brain.Store
  @store Application.get_env(:elix, :brain, ProcessStore)

  defdelegate start_link, to: @store
  defdelegate add(key, item), to: @store
  defdelegate get(key), to: @store
  defdelegate set(key, val), to: @store
  defdelegate delete(key), to: @store
  defdelegate remove(key, item), to: @store
  defdelegate at_index(key, index), to: @store
end
