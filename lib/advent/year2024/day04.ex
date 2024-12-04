defmodule Advent.Year2024.Day04 do
  def part1(input) do
    plane = input
      |> Input.to_tupple_of_tupples()
      |> Plane.new()

    0..359//45
    |> Enum. reduce(0, fn rotation, acc ->
      count = Plane.rotate(plane, rotation)
        |> Tuple.to_list()
        |> Enum.map(fn line ->
          string = Tuple.to_list(line)
          |> Enum.map(&(Atom.to_string(&1)))
          |> List.to_string()

          Regex.scan(~r/XMAS/, string)
          |> Enum.count()
        end)
        |> Enum.sum()
      acc + count
    end)
  end

  def part2(input) do
    plane =
      input
      |> Input.to_tupple_of_tupples()
      |> Plane.new()

    plane
    |> Plane.scan(:A, 0, fn x, y ->
      d1 = %{}
        |> Map.update(Plane.at(plane, x - 1, y - 1), 1, &(&1+1))
        |> Map.update(Plane.at(plane, x + 1, y + 1), 1, &(&1+1))

      d2 = %{}
        |> Map.update(Plane.at(plane, x - 1, y + 1), 1, &(&1+1))
        |> Map.update(Plane.at(plane, x + 1, y - 1), 1, &(&1+1))

      if %{S: 1, M: 1} === d1 && %{ S: 1, M: 1 } === d2, do: 1, else: 0
    end)
    |> Enum.sum()
  end
end
