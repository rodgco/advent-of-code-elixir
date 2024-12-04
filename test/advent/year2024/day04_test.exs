defmodule Advent.Year2024.Day04Test do
  use ExUnit.Case
  import Elixir.Advent.Year2024.Day04
  @moduletag :"y2024.d04"
  @moduletag :y2024

  @tag :"y2024.d04.p1"
  test "part1" do
    input = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """

    result = part1(input)

    assert 18 === result
  end

  @tag :"y2024.d04.p2"
  test "part2" do
    input = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """

    result = part2(input)

    assert 9 === result
  end
end
