defmodule Aloi.NegativeTest do
  use ExUnit.Case

  test "Raise when no implementation chosen" do
    assert_raise RuntimeError, 
    "No compile-time implementation provided for Aloi.NegativeTest.Api. " <> 
    "Please provide one by adding the following line to your config.exs: " <>
    "'config :aloi, Aloi.NegativeTest.Api, implementation: <IMPL>'",
    fn ->
      ast = quote do 
        defmodule Api do
          use Aloi, otp_app: :aloi
          defcallback greet(name :: String.t()) :: String.t()
        end
        defmodule MyDefaultImplementation do
          def greet(name) do
            "Hello #{name}"
          end
        end
      end
      Code.eval_quoted(ast, [], __ENV__)
    end
  end

  test "Raise when calling with no_implementation" do
    assert_raise RuntimeError, "Attempt to call aloi Aloi.TestCaseNoImpl with no defined implementation", fn ->
      Aloi.TestCaseNoImpl.greet("foo")
    end
  end
end
