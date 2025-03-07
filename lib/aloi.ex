defmodule Aloi do
  @moduledoc """
  Aloi - `Another layer of indirection` - provides a way to define "proxy" module layer that delegates all its callbacks to another module,
  which can be defined in config or use a default implementation.

  It can be useful when you want to have a module that can be easily swapped with a specific implementation,
  or to disconnect the module from the implementation details in microservices architecture, so no compile-time dependencies arise.

  ## Examples

      iex> defmodule MyModule do
      iex>   use Aloi, otp_app: :my_app
      iex>
      iex>   defcallback my_check(arg1 :: integer, arg2 :: binary) :: boolean
      iex> end
      iex>
      iex> defmodule MyDefaultImplementation do
      iex>   def my_check(_arg1, _arg2) do
      iex>     # some implementation
      iex>
      iex>     false
      iex>   end
      iex> end
      iex>
      iex> defmodule MyTest do
      iex>   def compare(arg1, arg2) do
      iex>     MyModule.my_check(arg1, arg2)
      iex>   end
      iex> end
      iex>
      iex> MyTest.compare(1, "test") == false
  """

  defmacro __using__(args) do
    callbacks =
      Keyword.get(args, :behaviour)
      |> Macro.expand(__ENV__)
      |> load_callbacks_from_behaviour()

    unless Keyword.has_key?(args, :otp_app), do: raise(":otp_app must be specified")
    otp_app = Keyword.get(args, :otp_app)

    quote do
      import Aloi, only: [defcallback: 1]

      @aloi_config_implementation unquote(otp_app)
                                  |> Application.compile_env(__MODULE__, [])
                                  |> Keyword.get(:implementation, nil)

      @global_dispatch_disabled unquote(otp_app)
                                |> Application.compile_env(:aloi, [])
                                |> Keyword.get(:no_implementation, false)

      @local_dispatch_disabled unquote(otp_app)
                               |> Application.compile_env(__MODULE__, [])
                               |> Keyword.get(:no_implementation, false)

      if not (@local_dispatch_disabled or @global_dispatch_disabled) and is_nil(@aloi_config_implementation) do
        raise "No compile-time implementation provided for #{inspect(__MODULE__)}. " <>
                "Please provide one by adding the following line to your config.exs: " <>
                "'config :#{unquote(otp_app)}, #{inspect(__MODULE__)}, implementation: <IMPL>'"
      end

      unquote(callbacks)
    end
  end

  defp load_callbacks_from_behaviour(nil), do: []

  defp load_callbacks_from_behaviour(module) do
    behaviour_info = module.behaviour_info(:callbacks)

    for {function_name, arity} <- behaviour_info do
      args = 0..arity |> Enum.to_list() |> tl() |> Enum.map(&Macro.var(:"arg#{&1}", Elixir))

      quote do
        def unquote(function_name)(unquote_splicing(args)) do
          if is_nil(@aloi_config_implementation) do
            raise "Attempt to call aloi #{inspect(__MODULE__)} with no defined implementation"
          end

          apply(@aloi_config_implementation, unquote(function_name), [unquote_splicing(args)])
        end
      end
    end
  end

  defmacro defcallback(a) do
    {:"::", _meta, [{function_name, _, typespec_args}, return_type]} = a

    args =
      typespec_args
      |> Enum.with_index(1)
      |> Enum.map(fn
        {{:"::", _, [{name, _, nil}, _type]}, _index} ->
          Macro.var(name, Elixir)

        {_type, index} ->
          Macro.var(:"arg#{index}", Elixir)
      end)

    quote do
      @spec unquote(function_name)(unquote_splicing(typespec_args)) :: unquote(return_type)
      if is_nil(@aloi_config_implementation) do
        def unquote(function_name)(unquote_splicing(args)) do
          raise "Attempt to call aloi #{inspect(__MODULE__)} with no defined implementation"
        end
      else
        def unquote(function_name)(unquote_splicing(args)) do
          apply(@aloi_config_implementation, unquote(function_name), [unquote_splicing(args)])
        end
      end

      @callback unquote(a)
    end
  end
end
