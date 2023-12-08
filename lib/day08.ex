defmodule Day08 do
  @doc """
  ## Examples
    iex> Day08.part1()
    12169
  """
  def part1 do
    [inst, network] =
      File.read!("input08.txt")
      |> String.split("\n\n")

    net_map =
      network
      |> String.split("\n")
      |> Enum.filter(&(String.length(&1) > 0))
      |> Enum.map(fn s ->
        [_, a, b, c] = Regex.run(~r/(.{3}) = \((.{3}), (.{3})\)/, s)
        {a, {b, c}}
      end)
      |> Map.new()

    sim(inst, "AAA", net_map, 0)
  end

  def sim(_, "ZZZ", _, i), do: i

  def sim(inst, current, map, i) do
    if String.at(inst, rem(i, String.length(inst))) == "L" do
      sim(inst, elem(map[current], 0), map, i + 1)
    else
      sim(inst, elem(map[current], 1), map, i + 1)
    end
  end

  @doc """
  ## Examples
    iex> Day08.part2()
    12030780859469
  """
  def part2 do
    [inst, network] =
      File.read!("input08.txt")
      |> String.split("\n\n")

    net_map =
      network
      |> String.split("\n")
      |> Enum.filter(&(String.length(&1) > 0))
      |> Enum.map(fn s ->
        [_, a, b, c] = Regex.run(~r/(.{3}) = \((.{3}), (.{3})\)/, s)
        {a, {b, c}}
      end)
      |> Map.new()

    Map.keys(net_map)
    |> Enum.filter(&(String.at(&1, 2) == "A"))
    |> Enum.flat_map(&find_cycle(inst, &1, net_map, 0, MapSet.new()))
    |> Enum.reduce(1, fn {_, n}, acc -> n * div(acc, Integer.gcd(n, acc)) end)
  end

  def find_cycle(inst, current, map, i, zs) do
    if MapSet.member?(zs, {current, rem(i, String.length(inst))}) do
      zs
      |> Enum.filter(&(String.at(elem(&1, 0), 2) == "Z"))
    else
      e = if String.at(inst, rem(i, String.length(inst))) == "L", do: 0, else: 1
      next = elem(map[current], e)
      find_cycle(inst, next, map, i + 1, MapSet.put(zs, {current, i}))
    end
  end
end
