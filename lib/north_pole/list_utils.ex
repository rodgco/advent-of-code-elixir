defmodule ListUtils do
  @moduledoc """
  Utility functions for working with lists.
  """

  @doc """
  Finds the middle element of a list.
  For lists with an odd number of elements, returns the middle element.
  For lists with an even number of elements, returns the element just after the middle.

  ## Examples

      iex> ListUtils.middle([1, 2, 3])
      2

      iex> ListUtils.middle([1, 2, 3, 4])
      3

      iex> ListUtils.middle([])
      nil

      iex> ListUtils.middle([1])
      1

  """
  def middle([]), do: nil
  def middle([elem]), do: elem

  def middle(list) when is_list(list) do
    # Calculate the middle index (rounds down for even-length lists)
    middle_index = div(length(list), 2)
    # Get the element at the middle index
    Enum.at(list, middle_index)
  end

  @doc """
  Splits a list at the first occurrence of a given value.
  Returns a tuple containing two lists: elements before and after the split value (exclusive).
  If the value is not found, returns the original list and an empty list.

  ## Examples

      iex> ListUtils.split_at_value([1, 2, 3, 4, 5], 3)
      {[1, 2], [4, 5]}

      iex> ListUtils.split_at_value([1, 2, 3, 4, 3, 5], 3)
      {[1, 2], [4, 3, 5]}

      iex> ListUtils.split_at_value([1, 2, 4, 5], 3)
      {[1, 2, 4, 5], []}

      iex> ListUtils.split_at_value([], 3)
      {[], []}

      iex> ListUtils.split_at_value([1, 2, 3, 4], 4)
      {[1, 2, 3, 4], []}

      iex> ListUtils.split_at_value([1, 2, 3, 4], 1)
      {[], [1, 2, 3, 4]}
  """
  def split_at_value(list, value) do
    split_at_value_recursive(list, value, [])
  end

  # Handle empty list
  defp split_at_value_recursive([], _value, acc) do
    {Enum.reverse(acc), []}
  end

  # When we find the value, split the list
  defp split_at_value_recursive([value | rest], value, acc) do
    {Enum.reverse(acc), rest}
  end

  # Keep accumulating elements until we find the value
  defp split_at_value_recursive([head | tail], value, acc) do
    split_at_value_recursive(tail, value, [head | acc])
  end

  @doc """
  Splits a list at all occurrences of a given value.
  Returns a list of sublists, excluding the split value.

  ## Examples

      iex> ListUtils.split_at_all_values([1, 2, 3, 4, 3, 5, 3, 6], 3)
      [[1, 2], [4], [5], [6]]

      iex> ListUtils.split_at_all_values([1, 2, 4, 5], 3)
      [[1, 2, 4, 5]]

      iex> ListUtils.split_at_all_values([], 3)
      [[]]

  """
  def split_at_all_values(list, value) do
    list
    |> split_at_all_values_recursive(value, [], [])
    |> Enum.reverse()
  end

  # Handle empty list
  defp split_at_all_values_recursive([], _value, current_segment, segments) do
    [Enum.reverse(current_segment) | segments]
  end

  # When we find the value, start a new segment
  defp split_at_all_values_recursive([value | rest], value, current_segment, segments) do
    split_at_all_values_recursive(rest, value, [], [Enum.reverse(current_segment) | segments])
  end

  # Keep accumulating elements in the current segment
  defp split_at_all_values_recursive([head | tail], value, current_segment, segments) do
    split_at_all_values_recursive(tail, value, [head | current_segment], segments)
  end
end
