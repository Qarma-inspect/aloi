# Aloi - Another Layer of Indirection

Aloi - `Another layer of indirection` - provides a way to define "proxy" module layer that delegates all its callbacks to another module, which can be defined in config.

It can be useful when you want to have a module that can be easily swapped with a specific implementation, or to disconnect the module from the implementation details in microservices architecture, so no compile-time dependencies arise.

## Example Usage
To use Aloi, it is required to configure an implementation module in `config.exs`:

```elixir
import Config
config :my_app, MyModule, implementation: MyImplementation
```


```elixir
defmodule MyModule do
  use Aloi, otp_app: :my_app

  defcallback my_check(arg1 :: integer, arg2 :: binary) :: boolean
end

defmodule MyImplementation do
  @behaviour MyModule

  @impl true
  def my_check(_arg1, _arg2) do
    # some implementation

    false
  end
end

defmodule MyTest do
  def compare(arg1, arg2) do
    MyModule.my_check(arg1, arg2)
  end
end

MyTest.compare(1, "test") == false
```

In cases where you do not define any implementation for an Aloi module (e.g. API projects), you may set the option `no_implementation: true` instead.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `aloi` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:aloi, "~> 0.1.1"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/aloi](https://hexdocs.pm/aloi).

