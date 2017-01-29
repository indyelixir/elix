defmodule Elix.Brain.Store do
  @callback start_link :: any

  @callback set(String.t, any) :: any
  @callback get(String.t) :: []
  @callback delete(String.t) :: any

  @callback add(String.t, any) :: any
  @callback remove(String.t, any) :: any
  @callback at_index(String.t, any) :: any
end
