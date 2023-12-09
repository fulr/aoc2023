defmodule Day09 do
  @doc """
  ## Examples
    iex> Day09.part1()
    1782868781
  """
  def part1 do
    File.read!("input09.txt")
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.map(fn s -> s |> String.split(" ") |> Enum.map(&String.to_integer/1) end)
    |> Enum.map(fn seq -> build_next(seq) end)
    |> Enum.sum()
  end

  def build_next(seq) do
    if Enum.all?(seq, &(&1 == 0)) do
      0
    else
      next =
        seq
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.map(fn [a, b] -> b - a end)

      build_next(next) + List.last(seq)
    end
  end

  @doc """
  ## Examples
    iex> Day09.part2()
    1057
  """
  def part2 do
    File.read!("input09.txt")
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.map(fn s -> s |> String.split(" ") |> Enum.map(&String.to_integer/1) end)
    |> Enum.map(fn seq -> build_prev(seq) end)
    |> Enum.sum()
  end

  def build_prev(seq) do
    if Enum.all?(seq, &(&1 == 0)) do
      0
    else
      next =
        seq
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.map(fn [a, b] -> b - a end)

      List.first(seq) - build_prev(next)
    end
  end
end
