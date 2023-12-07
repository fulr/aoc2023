defmodule Day05 do
  @doc """
  ## Examples
    iex> Day05.part1()
    26426
  """
  def part1 do
    data = parse()

    order = [
      "seed-to-soil map",
      "soil-to-fertilizer map",
      "fertilizer-to-water map",
      "water-to-light map",
      "light-to-temperature map",
      "temperature-to-humidity map",
      "humidity-to-location map"
    ]

    [seeds] = data["seeds"]

    seeds
    |> Enum.map(fn s ->
      for t <- order, reduce: s do
        acc -> transform(data[t], acc)
      end
    end)
    |> Enum.min()
  end

  @doc """
  ## Examples
    iex> Day05.part2()
    67953
  """
  def part2 do
    data = parse()

    order = [
      "seed-to-soil map",
      "soil-to-fertilizer map",
      "fertilizer-to-water map",
      "water-to-light map",
      "light-to-temperature map",
      "temperature-to-humidity map",
      "humidity-to-location map"
    ]

    [seeds] = data["seeds"]

    seed_ranges = seeds |> Enum.chunk_every(2)

    order
    |> Enum.reduce(seed_ranges, fn t, acc ->
      transform2(data[t], acc)
    end)
    |> Enum.min_by(fn [a, _] -> a end)
  end

  def parse do
    File.read!("input05.txt")
    |> String.split("\n\n")
    |> Enum.map(fn s ->
      [head, rest] = s |> String.split(":")

      sp =
        rest
        |> String.split("\n")
        |> Enum.filter(&(String.length(&1) > 0))
        |> Enum.map(fn l ->
          l
          |> String.split(" ")
          |> Enum.filter(&(String.length(&1) > 0))
          |> Enum.map(&String.to_integer/1)
        end)

      {head, sp}
    end)
    |> Map.new()
  end

  def transform([], i), do: i
  def transform([[to, from, size] | _], i) when i in from..(from + size), do: i - from + to
  def transform([_ | r], i), do: transform(r, i)

  def transform2(xs, i) do
    splitted =
      xs
      |> Enum.reduce(i, &split_range/2)
      |> Enum.filter(fn [_, r] -> r >= 0 end)

    todo = Enum.map(splitted, &{:todo, &1})

    xs
    |> Enum.reduce(todo, fn x, acc -> Enum.map(acc, &transform2int(x, &1)) end)
    |> Enum.map(&elem(&1, 1))
    |> dbg()
  end

  def transform2int([to, from, size], {:todo, [x, r]})
      when x >= from and x + r <= from + size,
      do: {:x, [x - from + to, r]}

  def transform2int(_, c), do: c

  def split_range([_, from, size], ranges) do
    right = from + size

    ranges
    |> Enum.flat_map(fn
      [x, r] when x <= from and from <= x + r -> [[x, from - 1 - x], [from, x + r - from]]
      c -> [c]
    end)
    |> Enum.flat_map(fn
      [x, r] when x <= right and right <= x + r ->
        [[x, right - x], [right + 1, x + r - right - 1]]

      c ->
        [c]
    end)
  end
end
