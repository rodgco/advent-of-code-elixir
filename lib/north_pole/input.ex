defmodule Input do
  def to_list(input) do
    input
    |> String.split("\n", trim: true)
  end

  def split_items(items, splitter, split_options \\ []) do
    items
    |> Enum.map(&String.split(&1, splitter, split_options))
  end

  def convert_items(items, types \\ []) do
    items
    |> Enum.map(&convert_item(&1, types))
  end

  def to_tupple_of_tupples(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.codepoints(line)
      |> Enum.map(&String.to_atom(&1))
      |> List.to_tuple()
    end)
    |> List.to_tuple()
  end

  def to_tupples(input, fun) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&fun.(&1))
    |> List.to_tuple()
  end

  @doc ~S"""
  Given a list of items and a list of types, convert each item to the respective type.

  ## Examples

    iex> NorthPole.InputHelper.convert_item(["1", "2"], [:integer, :integer])
    [1, 2]

  """
  def convert_item(item, types \\ []) do
    [item, types]
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
  end
end
