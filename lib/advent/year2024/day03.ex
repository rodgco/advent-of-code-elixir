defmodule Advent.Year2024.Day03 do
  def part1(input) do
    Regex.scan(~r/mul\((\d*),(\d*)\)/, input)
    |> Enum.reduce(0, &(&2+process_mul(&1)))
  end

  def part2(input) do
    Regex.scan(~r/mul\((\d*),(\d*)\)|do\(\)|don't\(\)/, input)
    |> Enum.reduce(%{ sum: 0, enabled: true}, fn instruction, state -> 
      cmd = hd(instruction)
      cond do
        cmd === "do()" ->
          %{ state | enabled: true }
        cmd === "don't()" ->
          %{ state | enabled: false }
        true ->
          if state.enabled do
            %{ state | sum: state.sum + process_mul(instruction) }
          else
            state
          end
      end
    end)
    |> IO.inspect

  end

  defp process_mul(mul) do
    [_, d1, d2] = mul
    d1 = String.to_integer(d1)
    d2 = String.to_integer(d2)
    d1*d2
  end
end 
