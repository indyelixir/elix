defmodule Elix.MessageScheduler.Store do
  @callback all :: List.t
  @callback add(String.t, String.t) :: any
  @callback remove(String.t) :: any
end
