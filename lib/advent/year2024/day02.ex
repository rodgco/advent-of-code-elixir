defmodule Advent.Year2024.Day02 do
  def part1(args) do
    args
    |> extract_list()
    |> Enum.map(&check(&1))
    |> Enum.count(& &1)
  end

  def part2(args) do
    args
    |> extract_list()
    |> Enum.map(&check(&1, problem_dampener: true))
    |> Enum.count(& &1)
  end

  defp extract_list(list) do
    list
    |> String.split("\n", trim: true)
    |> Enum.map(&split_and_convert_entry(&1))
  end

  defp split_and_convert_entry(entry) do
    entry
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end

  defp check(report) do
    report =
      if List.last(report) < List.first(report) do
        Enum.reverse(report)
      else
        report
      end

    case do_check(report) do
      {:ok, _} ->
        :ok

      {:nok, _} ->
        nil
    end
  end

  defp check(report, problem_dampener: true) do
    report
    |> check()
    |> case do
      nil ->
        report
        |> Enum.with_index(fn _, index ->
          report
          |> List.delete_at(index)
          |> check()
        end)
        |> Enum.any?()
        |> if do
          :ok
        end

      _ ->
        :ok
    end
  end

  defp do_check(report) do
    report
    |> Enum.reduce({:ok, List.first(report) - 1}, fn
      _, {:nok, value} ->
        {:nok, value}

      value, {:ok, last} ->
        case value - last do
          x when x in 1..3 ->
            {:ok, value}

          _ ->
            {:nok, value}
        end
    end)
  end
end
