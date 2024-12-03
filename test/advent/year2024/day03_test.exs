defmodule Advent.Year2024.Day03Test do
  use ExUnit.Case
  import Elixir.Advent.Year2024.Day03
  @moduletag :"y2024.d03"
  @moduletag :y2024

  @tag :"y2024.d03.p1"
  test "part1" do
    input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
    result = part1(input)

    assert 161 === result
  end

  @tag :"y2024.d03.p2"
  test "part2" do
    input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
    result = part2(input)

    assert result
  end
end
