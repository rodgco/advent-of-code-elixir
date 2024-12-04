defmodule Advent.Year2024.Day04 do
  def part1(input) do
    plane = get_plane(input)

    0..7
    |> Enum.reduce(0, fn rotation, acc ->
      count =
        Plane.rotate(plane, rotation, fn string ->
          Regex.scan(~r/XMAS/, string)
          |> Enum.count()
        end)
        |> Enum.sum()

      acc + count
    end)
  end

  def part2(input) do
    get_plane(input)
    |> Plane.scan(:A, 0, fn plane, x, y ->
      if is_valid?(plane, x - 1, y - 1, x + 1, y + 1) &&
           is_valid?(plane, x - 1, y + 1, x + 1, y - 1),
         do: 1,
         else: 0
    end)
    |> Enum.sum()
  end

  defp is_valid?(plane, x1, y1, x2, y2) do
    %{}
    |> Map.update(Plane.at(plane, x1, y1), 1, &(&1 + 1))
    |> Map.update(Plane.at(plane, x2, y2), 1, &(&1 + 1))
    |> Map.equal?(%{S: 1, M: 1})
  end

  defp get_plane(input) do
    input
    |> Input.to_tupples(fn line ->
      String.codepoints(line)
      |> Enum.map(&String.to_atom(&1))
      |> List.to_tuple()
    end)
    |> Plane.new()
  end
end
