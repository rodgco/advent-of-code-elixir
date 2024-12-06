defmodule Advent.Year2024.Day05 do
  def part1(input) do
    [rules, updates] = get_data(input)

    updates
    |> TaskProcessor.process_items(fn update ->
      is_correct = analyse_update(update, rules)
      if is_correct, do: ListUtils.middle(update), else: 0
    end)
    |> Enum.reduce(0, fn {:ok, page}, acc ->
      acc + page
    end)
  end

  def part2(input) do
    [rules, updates] = get_data(input)

    updates
    |> TaskProcessor.process_items(fn update ->
      update
      |> sort_update(rules)
      |> ListUtils.middle()
    end)
    |> Enum.reduce(0, fn {:ok, page}, acc ->
      acc + page
    end)
    |> Kernel.-(part1(input))
  end

  def analyse_update([], _rules) do
    true
  end

  def analyse_update(update, rules) do
    [page | next_pages] = update

    next_pages
    |> Enum.reduce(true, fn next_page, acc ->
      acc && is_in_order?(page, next_page, rules)
    end) && analyse_update(next_pages, rules)
  end

  defp is_in_order?(page, next_page, rules) do
    Enum.any?(rules, &({page, next_page} === &1)) ||
      !Enum.any?(rules, &({next_page, page} === &1))
  end

  def sort_update(update, rules) do
    update
    |> Enum.sort(fn page, next_page ->
      is_in_order?(page, next_page, rules)
    end)
  end

  defp get_data(input) do
    [rules, updates] = Regex.split(~r/\n\n/, input)

    rules =
      rules
      |> Input.to_list(fn rule ->
        String.split(rule, "|", trim: true)
        |> Enum.map(&String.to_integer(&1))
        |> List.to_tuple()
      end)

    updates =
      updates
      |> Input.to_list(fn update ->
        String.split(update, ",", trim: true)
        |> Enum.map(&String.to_integer(&1))
      end)

    [rules, updates]
  end
end
