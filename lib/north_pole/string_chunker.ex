defmodule StringChunker do
  @moduledoc """
  Provides functionality to break down strings into chunks of specified size.
  """

  @doc """
  Splits a string into a list of chunks of size n.
  The last chunk may be smaller if the string length is not divisible by n.

  ## Parameters
    - string: The input string to be chunked
    - chunk_size: The size of each chunk

  ## Examples
      iex> StringChunker.chunk_string("hello world", 3)
      ["hel", "lo ", "wor", "ld"]

      iex> StringChunker.chunk_string("abcdef", 2)
      ["ab", "cd", "ef"]

      iex> StringChunker.chunk_string("test", 5)
      ["test"]
  """
  @spec chunk_string(String.t(), pos_integer()) :: [String.t()]
  def chunk_string(string, chunk_size)
      when is_binary(string) and is_integer(chunk_size) and chunk_size > 0 do
    string
    |> String.codepoints()
    |> Enum.chunk_every(chunk_size)
    |> Enum.map(&Enum.join/1)
  end

  # Handle empty string case
  def chunk_string("", _), do: []

  # Handle invalid inputs
  def chunk_string(_, chunk_size) when not is_integer(chunk_size) or chunk_size <= 0 do
    raise ArgumentError, "chunk_size must be a positive integer"
  end
end
