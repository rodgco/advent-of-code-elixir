defmodule Plane do
  defstruct width: 0, height: 0, data: ""

  def new(width, height, initial) do
    %Plane{width: width, height: height, data: initial}
  end

  def new(initial) do
    width = tuple_size(elem(initial, 0))
    height = tuple_size(initial)

    new(width, height, initial)
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
  def at(plane, x, y) do
    cond do
      x > plane.width - 1 -> {:error, :out_of_bounds}
      y > plane.height - 1 -> {:error, :out_of_bounds}
      true -> elem(elem(plane.data, y), x)
    end
  end

  def rotate(plane, 0) do
    plane.data
  end

  def rotate(plane, 45) do
    diagonals = plane.width + plane.height - 1

    for d <- 0..(diagonals - 1), reduce: {} do
      acc ->
        Tuple.append(
          acc,
          for x <- 0..(plane.width - 1),
              y <- 0..(plane.height - 1),
              x + y === d,
              reduce: {} do
            acc -> Tuple.append(acc, Plane.at(plane, x, y))
          end
        )
    end
  end

  def rotate(plane, 90) do
    for x <- 0..(plane.height - 1), reduce: {} do
      acc ->
        Tuple.append(
          acc,
          for y <- (plane.width - 1)..0//-1, reduce: {} do
            acc -> Tuple.append(acc, Plane.at(plane, x, y))
          end
        )
    end
  end

  def rotate(plane, 135) do
    Plane.rotate(
      new(Plane.rotate(plane, 90)),
      45
    )
  end

  def rotate(plane, 180) do
    for y <- (plane.height - 1)..0//-1, reduce: {} do
      acc ->
        Tuple.append(
          acc,
          for x <- (plane.width - 1)..0//-1, reduce: {} do
            acc -> Tuple.append(acc, Plane.at(plane, x, y))
          end
        )
    end
  end

  def rotate(plane, 225) do
    diagonals = plane.width + plane.height - 1

    for d <- (diagonals - 1)..0//-1, reduce: {} do
      acc ->
        Tuple.append(
          acc,
          for x <- (plane.width - 1)..0//-1,
              y <- 0..(plane.height - 1),
              x + y === d,
              reduce: {} do
            acc -> Tuple.append(acc, Plane.at(plane, x, y))
          end
        )
    end
  end

  def rotate(plane, 270) do
    for x <- (plane.height - 1)..0//-1, reduce: {} do
      acc ->
        Tuple.append(
          acc,
          for y <- 0..(plane.width - 1), reduce: {} do
            acc -> Tuple.append(acc, Plane.at(plane, x, y))
          end
        )
    end
  end

  def rotate(plane, 315) do
    Plane.rotate(
      new(Plane.rotate(plane, 270)),
      45
    )
  end
end
