defmodule Aloi.TestCaseNoImpl do
  use Aloi, otp_app: :aloi

  defcallback greet(name :: String.t()) :: String.t()
end
