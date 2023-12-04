defmodule Day03 do
  @doc """
  ## Examples
    iex> Day03.part1()
    2278
  """
  def part1 do
    {parts, numbers} =
      File.read!("input03.txt")
      |> String.split("\n")
      |> Enum.filter(fn s -> String.length(s) > 0 end)
      |> Enum.map(&analyse/1)
      |> Enum.with_index()
      |> Enum.flat_map(fn {l, nr} -> Enum.map(l, fn t -> Map.put(t, :line, nr) end) end)
      |> Enum.split_with(fn %{type: t} -> t == :part end)

    numbers
    |> Enum.filter(fn %{start: start, stop: stop, line: line} ->
      Enum.any?(parts, fn %{pos: pos, line: l} ->
        pos in (start - 1)..(stop + 1) && l in (line - 1)..(line + 1)
      end)
    end)
    |> Enum.map(&Map.get(&1, :value))
    |> Enum.sum()
  end

  def analyse(line), do: analyse(line, 0, 0, 0, [])

  def analyse("", 0, _, _, result), do: result

  def analyse("", n, start, stop, result),
    do: [%{type: :number, value: n, start: start, stop: stop - 1} | result]

  def analyse("." <> r, 0, 0, stop, result), do: analyse(r, 0, 0, stop + 1, result)

  def analyse("." <> r, n, start, stop, result) do
    [
      %{type: :number, value: n, start: start, stop: stop - 1}
      | analyse(r, 0, 0, stop + 1, result)
    ]
  end

  def analyse(<<c, r::bitstring>>, 0, 0, stop, result) when c >= ?0 and c <= ?9 do
    analyse(r, c - ?0, stop, stop + 1, result)
  end

  def analyse(<<c, r::bitstring>>, n, start, stop, result) when c >= ?0 and c <= ?9 do
    analyse(r, n * 10 + c - ?0, start, stop + 1, result)
  end

  def analyse(<<c, r::bitstring>>, 0, 0, stop, result) do
    [%{type: :part, value: c, pos: stop} | analyse(r, 0, 0, stop + 1, result)]
  end

  def analyse(<<c, r::bitstring>>, n, start, stop, result) do
    [
      %{type: :part, value: c, pos: stop},
      %{type: :number, value: n, start: start, stop: stop - 1}
      | analyse(r, 0, 0, stop + 1, result)
    ]
  end

  @doc """
  ## Examples
    iex> Day03.part2()
    80403602
  """
  def part2 do
    {parts, numbers} =
      File.read!("input03.txt")
      |> String.split("\n")
      |> Enum.filter(&(String.length(&1) > 0))
      |> Enum.map(&analyse/1)
      |> Enum.with_index()
      |> Enum.flat_map(fn {l, nr} -> Enum.map(l, fn t -> Map.put(t, :line, nr) end) end)
      |> Enum.split_with(&(&1.type == :part))

    parts
    |> Enum.filter(&(&1.value == ?*))
    |> Enum.map(fn %{pos: pos, line: line} ->
      Enum.filter(numbers, fn %{start: start, stop: stop, line: l} ->
        pos in (start - 1)..(stop + 1) && l in (line - 1)..(line + 1)
      end)
    end)
    |> Enum.map(fn
      [%{value: a}, %{value: b}] -> a * b
      _ -> 0
    end)
    |> Enum.sum()
  end
end
