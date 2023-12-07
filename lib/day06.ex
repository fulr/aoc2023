defmodule Day06 do
  @doc """
  ## Examples
    iex> Day06.part1()
    2278
  """
  def part1 do
    races = [
      %{dist: 377, time: 51},
      %{dist: 1171, time: 69},
      %{dist: 1224, time: 98},
      %{time: 78, dist: 1505}
    ]

    races
    |> Enum.map(fn race ->
      Enum.count(1..race.time, &(&1 * (race.time - &1) > race.dist))
    end)
    |> Enum.product()
  end

  @doc """
  ## Examples
    iex> Day06.part2()
    80406602
  """
  def part2 do
    time = 51_699_878
    dist = 377_117_112_241_505

    Enum.count(1..time, &(&1 * (time - &1) > dist))
  end
end
