defmodule Advent.Year2024.Day02Test do
  use ExUnit.Case
  import Elixir.Advent.Year2024.Day02
  @moduletag :"y2024.d02"
  @moduletag :y2024

  @tag :"y2024.d02.p1"
  test "part1" do
    input = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

    result = part1(input)

    assert 2 === result
  end

  @tag :"y2024.d02.p1.e1"
  test "part1 edge case #1" do
    input = """
    39 38 36 34 31 28 25
    """

    result = part1(input)

    assert 1 === result
  end

  @tag :"y2024.d02.p2"
  test "part2" do
    input = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

    result = part2(input)

    assert 4 === result
  end
end
