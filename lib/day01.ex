defmodule Day01 do
  @doc """
  ## Examples
    iex> Day01.part1()
    56506
  """
  def part1 do
    File.read!("input01.txt")
    |> String.split("\n")
    |> Enum.filter(fn s -> String.length(s) > 0 end)
    |> Enum.map(fn s ->
      c = c_digits(s)
      i = Enum.at(c, 0) * 10 + Enum.at(c, -1)
      {s, c, i}
    end)
    |> Enum.map(&elem(&1, 2))
    |> Enum.sum()
    |> dbg()
  end

  @doc """
  ## Examples
    iex> Day01.part2()
    56017
  """
  def part2 do
    File.read!("input01.txt")
    |> String.split("\n")
    |> Enum.filter(fn s -> String.length(s) > 0 end)
    |> Enum.map(fn s ->
      c = convert_digits(s)
      i = Enum.at(c, 0) * 10 + Enum.at(c, -1)
      {s, c, i}
    end)
    |> Enum.map(&elem(&1, 2))
    |> Enum.sum()
  end

  def c_digits(""), do: []
  def c_digits(<<c, r::binary>>) when c >= ?1 and c <= ?9, do: [c - ?0 | c_digits(r)]
  def c_digits(<<_c, r::binary>>), do: c_digits(r)

  def convert_digits(""), do: []
  def convert_digits(<<"one", r::binary>>), do: [1 | convert_digits("e" <> r)]
  def convert_digits(<<"two", r::binary>>), do: [2 | convert_digits("o" <> r)]
  def convert_digits(<<"three", r::binary>>), do: [3 | convert_digits("e" <> r)]
  def convert_digits(<<"four", r::binary>>), do: [4 | convert_digits(r)]
  def convert_digits(<<"five", r::binary>>), do: [5 | convert_digits("e" <> r)]
  def convert_digits(<<"six", r::binary>>), do: [6 | convert_digits(r)]
  def convert_digits(<<"seven", r::binary>>), do: [7 | convert_digits("n" <> r)]
  def convert_digits(<<"eight", r::binary>>), do: [8 | convert_digits("t" <> r)]
  def convert_digits(<<"nine", r::binary>>), do: [9 | convert_digits("e" <> r)]
  def convert_digits(<<c, r::binary>>) when c >= ?1 and c <= ?9, do: [c - ?0 | convert_digits(r)]
  def convert_digits(<<_c, r::binary>>), do: convert_digits(r)
end
