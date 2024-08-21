defmodule Mix.Tasks.D02.P1 do
  use Mix.Task

  import AdventOfCode.Day02

  @shortdoc "Day 02 Part 1"
  def run(args) do
    day = 2
    year = 2023
    input = AdventOfCode.Input.get!(day, year)

    loaded = %{ red: 12, green: 13, blue: 14 }

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1(loaded) end}),
      else:
        input
        |> part1(loaded)
        |> IO.inspect(label: "Part 1 Results")
  end
end
