defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  @tag :skip
  test "part1" do
    input = ~w(1abc2 pqr3stu8vwx a1b2c3d4e5f treb7uchet) |> Enum.join("\n")
    result = part1(input)

    assert 142 == result
  end

  @tag :skip
  test "part2" do
    input = ~w(
      two1nine
      eightwothree
      abcone2threexyz
      xtwone3four
      4nineeightseven2
      zoneight234
      7pqrstsixteen
    ) |> Enum.join("\n")
    result = part2(input)

    assert 281 = result
  end
end
