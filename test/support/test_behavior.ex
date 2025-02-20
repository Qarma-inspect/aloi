defmodule Aloi.Test.Behaviour do
  @callback do_something(name :: String.t()) :: {:ok, String.t()}
end
