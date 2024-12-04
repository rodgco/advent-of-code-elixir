defmodule NorthPole.Computer do
  defmodule Tokenizer do
    @doc ~S"""
    Parses a raw instruction, like `"mul(12,10)"` into a tokenized list, following the hardcoded
    specs.

    ## Examples

      iex> NorthPole.Computer.Tokenizer.tokenize("mul(12,10)")
      [:mul, 12, 10]

    """
    def tokenize(instruction) do
      [token | params] = Regex.split(~r/,|\(|\)/, instruction, trim: true)

      token = String.to_atom(token)

      values =
        [params, spec(token)]
        |> Enum.zip()
        |> Enum.map(fn {value, type} ->
          case type do
            :integer -> String.to_integer(value)
            :float -> String.to_float(value)
            :atom -> String.to_atom(value)
            :string -> value
            _ -> value
          end
        end)

      [token | values]
    end

    defp spec(:mul) do
      [:integer, :integer]
    end

    defp spec(_token) do
      []
    end
  end

  def initialize() do
    %{
      instruction: nil,
      enabled: true,
      value: 0
    }
  end

  @doc ~S"""
  Runs the loaded instruction against the state.

  Some instructions alter the value stored, like `[:mul, 10, 12]`, while others alter the state
  behavior, like `[:do]` and `[:"don't"]`, that enables and disables the execution of the following
  instructions.

  The instruction is cleared after running.

  ## Examples

    iex> NorthPole.Computer.run(%{ instruction: [:mul, 12, 10], enabled: true, value: 10 })
    %{ instruction: nil, enabled: true, value: 130 }

    iex> NorthPole.Computer.run(%{ instruction: [:mul, 12, 10], enabled: false, value: 10 })
    %{ instruction: nil, enabled: false, value: 10 }

    iex> NorthPole.Computer.run(%{ instruction: [:do], enabled: true, value: 10 })
    %{ instruction: nil, enabled: true, value: 10 }

    iex> NorthPole.Computer.run(%{ instruction: [:do], enabled: false, value: 10 })
    %{ instruction: nil, enabled: true, value: 10 }

    iex> NorthPole.Computer.run(%{ instruction: [:"don't"], enabled: true, value: 10 })
    %{ instruction: nil, enabled: false, value: 10 }

    iex> NorthPole.Computer.run(%{ instruction: [:"don't"], enabled: false, value: 10 })
    %{ instruction: nil, enabled: false, value: 10 }
  """
  def run(%{instruction: [:mul, d1, d2], enabled: enabled, value: value}) do
    case enabled do
      true ->
        %{instruction: nil, enabled: enabled, value: value + d1 * d2}

      false ->
        %{instruction: nil, enabled: enabled, value: value}
    end
  end

  def run(%{instruction: [:do], value: value}) do
    %{instruction: nil, enabled: true, value: value}
  end

  def run(%{instruction: [:"don't"], value: value}) do
    %{instruction: nil, enabled: false, value: value}
  end
end
