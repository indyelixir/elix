defmodule Elix.Brain.Store do
  @callback start_link :: any

  @callback set(String.t, list) :: any
  @callback get(String.t) :: list
  @callback delete(String.t) :: any

  @callback add(String.t, any) :: any
  @callback remove(String.t, any) :: any
  @callback at_index(String.t, integer) :: any
end
