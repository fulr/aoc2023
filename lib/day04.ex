defmodule Day04 do
  @doc """
  ## Examples
    iex> Day04.part1()
    26426
  """
  def part1 do
    File.read!("input04.txt")
    |> String.split("\n")
    |> Enum.filter(fn s -> String.length(s) > 0 end)
    |> Enum.map(fn s ->
      [_card, info] = String.split(s, ": ")
      [winning, numbers] = String.split(info, " | ")

      parsed_winning =
        winning
        |> String.split(" ")
        |> Enum.filter(fn x -> String.length(x) > 0 end)
        |> Enum.map(&String.to_integer/1)

      parsed_numbers =
        numbers
        |> String.split(" ")
        |> Enum.filter(fn x -> String.length(x) > 0 end)
        |> Enum.map(&String.to_integer/1)

      count = Enum.count(parsed_numbers, fn x -> Enum.member?(parsed_winning, x) end)

      if count > 0, do: 2 ** (count - 1), else: 0
    end)
    |> Enum.sum()
  end

  @doc """
  ## Examples
    iex> Day04.part2()
    67953
  """
  def part2 do
    File.read!("input04.txt")
    |> String.split("\n")
    |> Enum.filter(fn s -> String.length(s) > 0 end)
    |> Enum.map(fn s ->
      [_card, info] = String.split(s, ": ")
      [winning, numbers] = String.split(info, " | ")

      parsed_winning =
        winning
        |> String.split(" ")
        |> Enum.filter(fn x -> String.length(x) > 0 end)
        |> Enum.map(&String.to_integer/1)

      parsed_numbers =
        numbers
        |> String.split(" ")
        |> Enum.filter(fn x -> String.length(x) > 0 end)
        |> Enum.map(&String.to_integer/1)

      Enum.count(parsed_numbers, fn x -> Enum.member?(parsed_winning, x) end)
    end)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {x, idx}, counts ->
      result =
        if x > 0 do
          copies = Map.get(counts, idx, 1)

          for n <- 1..x, reduce: counts do
            acc ->
              Map.update(acc, idx + n, 1 + copies, &(&1 + copies))
          end
        else
          counts
        end

      Map.put_new(result, idx, 1)
    end)
    |> Map.values()
    |> Enum.sum()
    |> dbg()
  end
end
