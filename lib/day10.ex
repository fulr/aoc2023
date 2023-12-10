defmodule Day10 do
  @doc """
  ## Examples
    iex> Day10.part1()
    6786
  """
  def part1 do
    pipe_map =
      File.read!("input10.txt")
      |> String.split("\n")
      |> Enum.filter(&(String.length(&1) > 0))
      |> Enum.with_index()
      |> Enum.flat_map(fn {s, y} ->
        s |> String.codepoints() |> Enum.with_index() |> Enum.map(fn {c, x} -> {{x, y}, c} end)
      end)
      |> Map.new()

    {start, _} = Enum.find(pipe_map, fn {_, c} -> c == "S" end)

    max_loop =
      [:north, :south, :east, :west]
      |> Enum.map(&find_way(pipe_map, start, &1, 0))
      |> Enum.max()

    div(max_loop, 2)
  end

  def next_dir(:north, "|"), do: :north
  def next_dir(:south, "|"), do: :south

  def next_dir(:west, "-"), do: :west
  def next_dir(:east, "-"), do: :east

  def next_dir(:south, "L"), do: :east
  def next_dir(:west, "L"), do: :north

  def next_dir(:south, "J"), do: :west
  def next_dir(:east, "J"), do: :north

  def next_dir(:north, "7"), do: :west
  def next_dir(:east, "7"), do: :south

  def next_dir(:north, "F"), do: :east
  def next_dir(:west, "F"), do: :south

  def next_dir(dir, "S"), do: dir
  def next_dir(_, _), do: false

  def dir(:north, {x, y}), do: {x, y - 1}
  def dir(:south, {x, y}), do: {x, y + 1}
  def dir(:east, {x, y}), do: {x + 1, y}
  def dir(:west, {x, y}), do: {x - 1, y}

  def find_way(map, pos, dir, l) do
    if map[pos] == "S" && l != 0 do
      l
    else
      next_dir = next_dir(dir, map[pos])

      if next_dir do
        next_pos = dir(next_dir, pos)
        find_way(map, next_pos, next_dir, l + 1)
      else
        -1
      end
    end
  end

  @doc """
  ## Examples
    iex> Day10.part2()
    495
  """
  def part2 do
    lines =
      File.read!("input10.txt")
      |> String.split("\n")
      |> Enum.filter(&(String.length(&1) > 0))

    pipe_map =
      lines
      |> Enum.with_index()
      |> Enum.flat_map(fn {s, y} ->
        s |> String.codepoints() |> Enum.with_index() |> Enum.map(fn {c, x} -> {{x, y}, c} end)
      end)
      |> Map.new()

    {start, _} = Enum.find(pipe_map, fn {_, c} -> c == "S" end)

    max_loop =
      [:north, :south, :east, :west]
      |> Enum.map(&find_full_pipe(pipe_map, start, &1, []))
      |> Enum.filter(&(length(&1) > 0))
      |> List.first()
      |> Enum.map(fn x -> {x, true} end)
      |> Map.new()

    lines
    |> Enum.with_index()
    |> Enum.map(fn {_, y} -> scan_line(pipe_map, max_loop, {0, y}, false, false, 0) end)
    |> Enum.sum()
  end

  def find_full_pipe(map, pos, dir, l) do
    if map[pos] == "S" && length(l) != 0 do
      l
    else
      next_dir = next_dir(dir, map[pos])

      if next_dir do
        next_pos = dir(next_dir, pos)
        find_full_pipe(map, next_pos, next_dir, [pos | l])
      else
        []
      end
    end
  end

  def scan_line(map, _, pos, _, _, incount) when not is_map_key(map, pos), do: incount

  def scan_line(map, loop, {x, y} = pos, inside, entry, incount) when not is_map_key(loop, pos) do
    scan_line(map, loop, {x + 1, y}, inside, entry, if(inside, do: incount + 1, else: incount))
  end

  def scan_line(map, loop, {x, y} = pos, inside, entry, incount) do
    case map[pos] do
      "-" ->
        scan_line(map, loop, {x + 1, y}, inside, entry, incount)

      "J" ->
        scan_line(
          map,
          loop,
          {x + 1, y},
          if(entry == "F", do: not inside, else: inside),
          false,
          incount
        )

      "7" ->
        scan_line(
          map,
          loop,
          {x + 1, y},
          if(entry == "L", do: not inside, else: inside),
          false,
          incount
        )

      "|" ->
        scan_line(map, loop, {x + 1, y}, not inside, false, incount)

      "S" ->
        scan_line(map, loop, {x + 1, y}, not inside, false, incount)

      "L" ->
        scan_line(map, loop, {x + 1, y}, inside, "L", incount)

      "F" ->
        scan_line(map, loop, {x + 1, y}, inside, "F", incount)
    end
  end
end
