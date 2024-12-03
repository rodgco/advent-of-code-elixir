defmodule Advent.Year2024.Day02 do
  def part1(input) do
    input
    |> process_input()
    # Check all the reports
    |> Enum.map(fn report -> is_safe?(report) end)
    # Count safe projects
    |> Enum.count(fn is_safe -> is_safe === true end)
  end

  def part2(input) do
    input
    |> process_input()
    # Check all the reports, with Probelm Dampener activated
    |> Enum.map(fn report -> is_safe?(report, problem_dampener: true) end)
    # Count safe projects
    |> Enum.count(fn is_safe -> is_safe === true end)
  end

  defp process_input(list) do
    list
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> split_and_convert_entry(line) end)
  end

  defp split_and_convert_entry(report) do
    report
    |> String.split(" ", trim: true)
    |> Enum.map(fn level -> String.to_integer(level) end)
  end

  defp is_safe?(report) do
    # Reverse the report levels in case of decreasing report
    report =
      if List.last(report) < List.first(report) do
        Enum.reverse(report)
      else
        report
      end

    {status, _} = report
    # Start the analysis with a number below the first one in the report (safe)
    |> Enum.reduce({true, List.first(report) - 1}, fn
      _value, {false, _last} ->
        {false, nil}

      value, {true, last} ->
        case value - last do
          x when x in 1..3 ->
            {true, value}

          _ ->
            {false, value}
        end
    end)

    status
  end

  defp is_safe?(report, problem_dampener: false) do
    is_safe?(report)
  end

  defp is_safe?(report, problem_dampener: true) do
    is_safe?(report)
    |> case do
      false ->
        # Activate Problem Dampener
        status =
          report
          # Brute force all cases removing only one level
          |> Enum.with_index(fn _value, index ->
            report
            |> List.delete_at(index)
            |> is_safe?()
          end)
          # Check if there is at least one any true report
          |> Enum.any?(fn status -> status === true end)

        if status, do: true, else: false

      true ->
        true
    end
  end
end
