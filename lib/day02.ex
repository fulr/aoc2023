defmodule Day02 do
  @doc """
  ## Examples
    iex> Day02.part1()
    2278
  """
  def part1 do
    File.read!("input02.txt")
    |> String.split("\n")
    |> Enum.filter(fn s -> String.length(s) > 0 end)
    |> Enum.map(fn s ->
      [game, parts] = String.split(s, ": ")
      [_, id] = String.split(game, " ")

      draws =
        String.split(parts, "; ")
        |> Enum.map(fn d ->
          String.split(d, ", ")
          |> Enum.map(fn x ->
            [n, c] = String.split(x, " ")
            {c, String.to_integer(n)}
          end)
          |> Map.new()
        end)

      ok =
        Enum.all?(draws, fn d ->
          Map.get(d, "red", 0) <= 12 &&
            Map.get(d, "green", 0) <= 13 &&
            Map.get(d, "blue", 0) <= 14
        end)

      {String.to_integer(id), draws, ok}
    end)
    |> Enum.filter(&elem(&1, 2))
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  @doc """
  ## Examples
    iex> Day02.part2()
    67953
  """
  def part2 do
    File.read!("input02.txt")
    |> String.split("\n")
    |> Enum.filter(fn s -> String.length(s) > 0 end)
    |> Enum.map(fn s ->
      [_game, parts] = String.split(s, ": ")

      draws =
        String.split(parts, "; ")
        |> Enum.map(fn d ->
          String.split(d, ", ")
          |> Enum.map(fn x ->
            [n, c] = String.split(x, " ")
            {c, String.to_integer(n)}
          end)
          |> Map.new()
        end)

      red = draws |> Enum.map(&Map.get(&1, "red", 0)) |> Enum.max()
      green = draws |> Enum.map(&Map.get(&1, "green", 0)) |> Enum.max()
      blue = draws |> Enum.map(&Map.get(&1, "blue", 0)) |> Enum.max()

      red * green * blue
    end)
    |> Enum.sum()
  end
end
