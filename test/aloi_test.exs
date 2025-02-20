defmodule AloiTest do
  use ExUnit.Case

  # alias AloiTest.MyDefaultImplementation
  # doctest Aloi, import: true

  test "Dispatch to configured module" do
    assert {:ok, "Hello world 42"} = Aloi.TestCaseConfig.Api.function1("Hello", 42)
  end

  test "Dispatch to configured module, with external behaviour" do
    assert {:ok, "Hello"} = Aloi.TestCaseExternalBehaviour.Api.do_something("Hello")
  end
end
