defmodule Advent.Year2024.Day01 do
  import NorthPole.InputHelper

  def part1(input) do
    {list1, list2} = extract_list(input)

    list1 = Enum.sort(list1)
    list2 = Enum.sort(list2)

    Enum.zip(list1, list2)
    |> Enum.reduce(0, fn {a, b}, acc -> acc + abs(a - b) end)
  end

  def part2(args) do
    {list1, list2} = extract_list(args)

    list2 = Enum.frequencies(list2)

    Enum.reduce(list1, 0, &(&2 + &1 * Map.get(list2, &1, 0)))
  end

  defp extract_list(list) do
    list
    |> input_to_list()
    |> split_items(" ", trim: true)
    |> convert_items([:integer, :integer])
    |> Stream.map(&List.to_tuple(&1))
    |> Enum.unzip()
  end
end
