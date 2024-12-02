defmodule Advent.Year2024.Day01 do
  def part1(args) do
    [ list1, list2 ] = args
    |> extract_list()

    list1 = Enum.sort(list1)
    list2 = Enum.sort(list2)

    [ list1, list2 ]
    |> Enum.zip()
    |> Enum.map(&(abs(elem(&1,0) - elem(&1, 1))))
    |> Enum.sum()
    end

  def part2(args) do
    [ list1, list2 ] = args
    |> extract_list()

    list2 = list2
      |> Enum.reduce(%{}, fn number, acc -> Map.update(acc, number, 1, fn c -> c + 1 end) end)

    list1
    |> Enum.reduce(0, fn number, acc -> acc + number * (Map.get(list2, number) || 0) end)
  end

  defp extract_list(list) do
    list
    |> String.split("\n", trim: true)
    |> Enum.map(&split_and_convert_entry(&1))
    |> Enum.reduce([[], []], fn entry, acc -> [ 
      [ Enum.at(entry, 0) | Enum.at(acc, 0)],
      [ Enum.at(entry, 1) | Enum.at(acc, 1)]
    ] end)
  end

  defp split_and_convert_entry(entry) do
    entry
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end
end
