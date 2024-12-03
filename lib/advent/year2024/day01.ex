defmodule Advent.Year2024.Day01 do
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
    |> String.split("\n", trim: true)
    |> Stream.map(&split_and_convert_entry(&1))
    |> Enum.unzip()
  end

  defp split_and_convert_entry(entry) do
    entry
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer(&1))
    |> List.to_tuple()
  end
end
