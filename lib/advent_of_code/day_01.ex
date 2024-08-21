defmodule AdventOfCode.Day01 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_calibration/1)
    |> Enum.sum
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_calibration_with_spelled_numbers/1)
    |> Enum.sum
  end

  defp parse_calibration(text) do
    first = Regex.run(~r/(\d{1})/, text, capture: :first)
      |> hd
      |> String.to_integer
    last = Regex.run(~r/(\d{1})[^\d]*$/, text, capture: :all_but_first)
      |> hd
      |> String.to_integer
    first * 10 + last
  end

  defp parse_calibration_with_spelled_numbers(text) do
    first = Regex.run(~r/^.*?([0-9]|one|two|three|four|five|six|seven|eight|nine)/, text, capture: :all_but_first)
      |> hd
      |> parse_number
    last = Regex.run(~r/^.*([0-9]|one|two|three|four|five|six|seven|eight|nine).*?$/, text, capture: :all_but_first)
      |> hd
      |> parse_number
    first * 10 + last
  end

  defp parse_number(text) when text in ~w(1 2 3 4 5 6 7 8 9 0), do: String.to_integer(text)

  defp parse_number(text) do
    case text do
      "one" -> 1
      "two" -> 2
      "three" -> 3
      "four" -> 4
      "five" -> 5
      "six" -> 6
      "seven" -> 7
      "eight" -> 8
      "nine" -> 9
      "zero" -> 0
      _ -> raise "Invalid number"
    end
  end
end
