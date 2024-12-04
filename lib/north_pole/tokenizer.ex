defmodule NorthPole.Computer do
  defmodule Tokenizer do
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
