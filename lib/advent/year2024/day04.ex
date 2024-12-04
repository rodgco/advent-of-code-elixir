defmodule Advent.Year2024.Day04 do
  def part1(input) do
    input
    |> Input.to_tupple_of_tupples()
  end

  # defp count(plane, rotation) do
  #   Plane.as_list(plane, rotation)
  #   |> Enum.reduce(0, &(&2 + Enum.count(Regex.scan(~r/XMAS/, &1))))
  # end

  def part2(input) do
    plane =
      input
      |> Input.to_list()
      |> Plane.new()

    plane
    |> Plane.scan("A", 0, fn x, y ->
      d1 = Plane.at(plane, x - 1, y - 1) <> Plane.at(plane, x + 1, y + 1)
      d2 = Plane.at(plane, x - 1, y + 1) <> Plane.at(plane, x + 1, y - 1)

      if (d1 === "MS" || d1 === "SM") && (d2 === "MS" || d2 === "SM") do
        1
      else
        0
      end
    end)
    |> List.flatten()
    |> Enum.sum()
  end
end
