defmodule Plane do
  defstruct width: 0, height: 0, data: ""

  def new(width, height, initial) when is_bitstring(initial) do
    %Plane{width: width, height: height, data: initial}
  end

  def new(initial) when is_list(initial) and is_bitstring(hd(initial)) do
    width = String.length(hd(initial))
    height = Enum.count(initial)

    new(width, height, Enum.join(initial, ""))
  end

  def scan(plane, char, default, fun) do
    for y <- 1..(plane.height - 2), x <- 1..(plane.width - 2) do
      if at(plane, x, y) === char do
        fun.(x, y)
      else
        default
      end
    end
  end

  @doc ~S"""
  Finds the element at the given position `x, y` (zero-based).
  """
  def at(plane, x, y, default \\ nil) do
    cond do
      x > plane.width - 1 -> {:error, :out_of_bounds}
      y > plane.height - 1 -> {:error, :out_of_bounds}
      true -> String.at(plane.data, x + y * plane.width) || default
    end
  end

  def as_list(plane, 0) do
    StringChunker.chunk_string(plane.data, plane.width)
  end

  def as_list(plane, rotation) when rotation in [90, 180, 270] do
    case rotation do
      90 ->
        for x <- 0..(plane.height - 1) do
          Enum.join(
            for y <- (plane.width - 1)..0//-1 do
              Plane.at(plane, x, y)
            end
          )
        end

      180 ->
        for y <- (plane.height - 1)..0//-1 do
          Enum.join(
            for x <- (plane.width - 1)..0//-1 do
              Plane.at(plane, x, y)
            end
          )
        end

      270 ->
        for x <- (plane.width - 1)..0//-1 do
          Enum.join(
            for y <- 0..(plane.height - 1) do
              Plane.at(plane, x, y)
            end
          )
        end
    end
  end

  def as_list(plane, rotation) when rotation in [45, 135, 225, 315] do
    diagonals = plane.width + plane.height - 1

    case rotation do
      45 ->
        for d <- 0..(diagonals - 1) do
          Enum.join(
            for x <- 0..(plane.width - 1),
              y <- 0..(plane.height - 1),
              x + y === d do
              Plane.at(plane, x, y)
            end
          )
        end

      135 ->
        Plane.as_list(
          new(Plane.as_list(plane, 90)),
          45
        )

      225 ->
        for d <- (diagonals - 1)..0//-1 do
          Enum.join(
            for x <- (plane.width - 1)..0//-1,
              y <- 0..(plane.height - 1),
              x + y === d do
              Plane.at(plane, x, y)
            end
          )
        end

      315 ->
        Plane.as_list(
          new(Plane.as_list(plane, 270)),
          45
        )
    end
  end
end
