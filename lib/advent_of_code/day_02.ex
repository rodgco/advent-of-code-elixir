defmodule AdventOfCode.Day02 do
  def part1(input, loaded) do
    input
    |> String.split("\n", trim: true) # -> a list of Game lines
    |> Enum.map(&parse_game_line/1) # -> a list of Games with hands
    |> Enum.map(&validate_game(&1, loaded)) # -> a list of games with valid flag
    |> Enum.filter(&Enum.at(&1, 1)) # -> a list of valid games
    |> Enum.map(&Enum.at(&1, 0)) # -> a list of valid game ids
    |> Enum.sum() # -> the total score
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true) # -> a list of Game lines
    |> Enum.map(&parse_game_line/1) # -> a list of Games with hands
    |> Enum.map(&calculate_game_power/1) # -> a list of game powers
    |> Enum.map(&Enum.at(&1, 1)) # -> a list of valid game powers
    |> Enum.sum() # -> the total score
  end

  @doc ~S"""
  Parse a game line into a game id and a list of hands.

  ## Examples

      iex> parse_game_line("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")
      [1, [%{blue: 3, red: 4}, %{red: 1, green: 2, blue: 6}, %{green: 2}]]
      iex> parse_game_line("Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue")
      [2, [%{blue: 1, green: 2}, %{green: 3, blue: 4, red: 1}, %{green: 1, blue: 1}]]

  """
  def parse_game_line(line) do
    # "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
    # -> ["Game 1", " 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"]
    [name, data] = line
    |> String.split(":")
   
    # "Game 1" -> 1
    game_id = name |> String.split(" ") |> Enum.at(1) |> String.to_integer

    # " 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
    # -> [%{blue: 3, red: 4}, %{red: 1, green: 2, blue: 6}, %{green: 2}]
    hands = data
      |> String.split(";") # -> [" 3 blue, 4 red", " 1 red, 2 green, 6 blue", " 2 green"]
      |> Enum.map(&String.split(&1, ",")) # -> [[" 3 blue", " 4 red"], [" 1 red", " 2 green", " 6 blue"], [" 2 green"]]
      |> Enum.map(&parse_hand/1) # -> [%{blue: 3, red: 4}, %{red: 1, green: 2, blue: 6}, %{green: 2}]

    [game_id, hands]
  end

  @doc ~S"""
  Parse an array of hand strings into a map of color to count.

  ## Examples

      iex> parse_hand([" 3 blue"])
      %{blue: 3}
      iex> parse_hand([" 4 red", " 3 blue"])
      %{red: 4, blue: 3}

  """
  def parse_hand(hand) do
    hand
    |> Enum.reduce(%{}, fn ball, acc ->
      [count, color] = ball |> String.trim() |> String.split(" ", trim: true)
      Map.put(acc, color |> String.to_atom, count |> String.to_integer)
    end)
  end

  @doc ~S"""
  Validate a game by checking if each hand can be played with the given loaded balls.

  ## Examples

      iex> validate_game([1, [%{blue: 3, red: 4}, %{red: 1, green: 2, blue: 6}, %{green: 2}]], %{red: 12, green: 13, blue: 14})
      [1, true]
      iex> validate_game([1, [%{blue: 3, red: 4}, %{red: 1, green: 2, blue: 6}, %{green: 2}]], %{red: 2, green: 13, blue: 14})
      [1, false]

  """
  def validate_game(game, loaded) do
    [game_id, hands] = game
    
    valid =
      hands # -> [%{blue: 3, red: 4}, %{red: 1, green: 2, blue: 6}, %{green: 2}]
      |> Enum.map(&validate_hand(&1, loaded)) # -> [true, true, true]
      |> Enum.reduce(true, &(&1 and &2)) # -> true

    [game_id, valid]
  end

  @doc ~S"""
  Validate a hand by checking if it can be played with the given loaded balls.
  
  ## Examples

      iex> validate_hand(%{blue: 3, red: 4}, %{red: 12, green: 13, blue: 14})
      true
      iex> validate_hand(%{blue: 3, red: 4}, %{red: 2, green: 13, blue: 14})
      false

  """
  def validate_hand(hand, loaded) do
    hand
    |> Enum.reduce(true, fn {color, count}, acc ->
      Map.get(loaded, color) >= count and acc
    end)
  end

  @doc ~S"""
  Calculate the power of a game by multiplying the maximum count of each color in all hands.

  ## Examples

      iex> calculate_game_power([1, [%{blue: 3, red: 4}, %{red: 1, green: 2, blue: 6}, %{green: 2}]])
      [1, 48]
      iex> calculate_game_power([1, [%{blue: 3, red: 4}, %{red: 1, green: 2, blue: 6}, %{green: 2}, %{red: 1, green: 2, blue: 6}]])
      [1, 48]

  """
  def calculate_game_power(game) do
    [game_id, hands] = game

    min_hand = %{ red: 0, green: 0, blue: 0 }

    power =
      hands
      |> Enum.reduce(min_hand, fn hand, acc ->
        Map.merge(acc, hand, fn _, a, b -> max(a, b) end)
      end)
      |> Enum.map(fn {_, count} -> count end)
      |> Enum.reduce(1, &(&1 * &2))

    [game_id, power]
  end
end

