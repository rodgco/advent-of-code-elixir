defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02


  @tag :skip
  test "part1" do
    loaded = %{ red: 12, green: 13, blue: 14 }

    input = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green\n\
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue\n\
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red\n\
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red\n\
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
    result = part1(input, loaded)

    assert 8 == result
  end

  @tag :skip
  test "part2" do
    input = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green\n\
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue\n\
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red\n\
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red\n\
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
    result = part2(input)

    assert 2286 == result
  end

  @tag :skip
  doctest AdventOfCode.Day02
end
