defmodule Advent.Year2024.Day03 do
  def part1(input) do
    Regex.scan(~r/mul\(\d*,\d*\)/, input)
    |> compute()
  end

  def part2(input) do
    Regex.scan(~r/mul\(\d*,\d*\)|do\(\)|don't\(\)/, input)
    |> compute()
  end

  def compute(raw_instructions) do
    import NorthPole.Computer.Tokenizer
    import NorthPole.Computer

    raw_instructions
    |> Enum.map(&tokenize(hd(&1)))
    |> Enum.reduce(initialize(), &run(%{&2 | instruction: &1}))
    |> Map.get(:value)
  end
end
