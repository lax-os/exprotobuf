defmodule Protobuf.DefineEnum do
  @moduledoc false

  @doc """
  Defines a new module which contains two functions, atom(value) and value(atom), for
  getting either the name or value of an enumeration value.
  """
  def def_enum(name, values, inject: inject) do
    enum_atoms = Enum.map values, fn {a, _} -> a end
    enum_values = Enum.map values, fn {_, v} -> v end
    contents = for {atom, value} <- values do
      quote do
        def value(unquote(atom)), do: unquote(value)
        def values(), do: unquote(enum_values)
        def atom(unquote(value)), do: unquote(atom)
        def atoms(), do: unquote(enum_atoms)
      end
    end
    if inject do
      quote do
        unquote(contents)
        def value(_), do: nil
        def atom(_),  do: nil
      end
    else
      quote do
        defmodule unquote(name) do
          unquote(contents)
          def value(_), do: nil
          def atom(_), do: nil
        end
      end
    end
  end
end
