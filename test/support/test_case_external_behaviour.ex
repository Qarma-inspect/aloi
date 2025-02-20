defmodule Aloi.TestCaseExternalBehaviour.Api do
  @moduledoc """
  Behaviour module
  """
  use Aloi,
    otp_app: :aloi,
    fallback: Aloi.TestCaseExternalBehaviour.Implementation,
    behaviour: Aloi.Test.Behaviour
end

defmodule Aloi.TestCaseExternalBehaviour.Implementation do
  @behaviour Aloi.Test.Behaviour

  @impl true
  def do_something(name) do
    {:ok, name}
  end
end
