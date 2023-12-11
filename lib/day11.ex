defmodule Day11 do
  @doc """
  ## Examples
    iex> Day11.part1()
    9329143
  """
  def part1 do
    star_dist(1)
  end

  def star_dist(f) do
    lines =
      File.read!("input11.txt")
      |> String.split("\n")
      |> Enum.filter(&(String.length(&1) > 0))

    star_map =
      lines
      |> Enum.with_index()
      |> Enum.flat_map(fn {s, y} ->
        s
        |> String.codepoints()
        |> Enum.with_index()
        |> Enum.filter(fn {c, _} -> c == "#" end)
        |> Enum.map(fn {_, x} -> {x, y} end)
      end)

    y_exp =
      lines
      |> Enum.with_index()
      |> Enum.filter(fn {l, y} -> not String.contains?(l, "#") end)
      |> Enum.map(fn {_, y} -> y end)

    x_exp =
      lines
      |> List.first()
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.filter(fn {_, x} -> not Enum.any?(star_map, fn {sx, _} -> x == sx end) end)
      |> Enum.map(fn {_, x} -> x end)

    expanded =
      star_map
      |> Enum.map(fn {x, y} ->
        ex = Enum.count(x_exp, &(&1 < x)) * f
        ey = Enum.count(y_exp, &(&1 < y)) * f
        {x + ex, y + ey}
      end)

    s =
      for {ax, ay} <- expanded, {bx, by} <- expanded, reduce: 0 do
        acc ->
          acc + abs(ax - bx) + abs(ay - by)
      end

    div(s, 2)
  end

  @doc """
  ## Examples
    iex> Day11.part2()
    710674907809
  """
  def part2 do
    star_dist(999_999)
  end
end
