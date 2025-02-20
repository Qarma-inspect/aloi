defmodule Aloi.TestCaseConfig.Api do
  @moduledoc """
  Behaviour module
  """
  use Aloi, otp_app: :aloi

  @doc """
  Blah bla
  """
  defcallback function1(name :: String.t(), number :: integer()) ::
                {:ok, String.t()} | {:error, String.t()}

  @doc """
  asd
  """
  defcallback function2(name :: String.t(), String.t()) :: :error
end

defmodule Aloi.TestCaseConfig.Implementation do
  @behaviour Aloi.TestCaseConfig.Api

  @impl Aloi.TestCaseConfig.Api
  def function1(arg, number) do
    {:ok, "#{arg} world #{number}"}
  end

  @impl Aloi.TestCaseConfig.Api
  def function2(_name, _arg1) do
    :error
  end
end
