defmodule Day07 do
  @doc """
  ## Examples
    iex> Day07.part1()
    2278
  """
  def part1 do
    card_order_map = %{
      "2" => 2,
      "3" => 3,
      "4" => 4,
      "5" => 5,
      "6" => 6,
      "7" => 7,
      "8" => 8,
      "9" => 9,
      "T" => 10,
      "J" => 11,
      "Q" => 12,
      "K" => 13,
      "A" => 14
    }

    File.read!("input07.txt")
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.map(fn x ->
      [card, bid] = String.split(x)

      t =
        card
        |> String.codepoints()
        |> Enum.frequencies()
        |> Map.values()
        |> Enum.sort(:desc)

      v =
        card |> String.codepoints() |> Enum.map(&card_order_map[&1])

      {t, v, String.to_integer(bid)}
    end)
    |> Enum.sort()
    |> Enum.with_index()
    |> Enum.map(fn {{_, _, bid}, idx} -> bid * (idx + 1) end)
    |> Enum.sum()
  end

  @doc """
  ## Examples
    iex> Day07.part2()
    80407602
  """
  def part2 do
    card_order_map = %{
      "2" => 2,
      "3" => 3,
      "4" => 4,
      "5" => 5,
      "6" => 6,
      "7" => 7,
      "8" => 8,
      "9" => 9,
      "T" => 10,
      "J" => 1,
      "Q" => 12,
      "K" => 13,
      "A" => 14
    }

    File.read!("input07.txt")
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.map(fn x ->
      [card, bid] = String.split(x)

      t =
        if card == "JJJJJ" do
          [5]
        else
          all =
            card
            |> String.codepoints()
            |> Enum.frequencies()

          {j, rest} = Map.pop(all, "J", 0)
          {k, v} = Enum.max_by(rest, fn {_, v} -> v end)

          Map.put(rest, k, v + j)
          |> Map.values()
          |> Enum.sort(:desc)
        end

      v =
        card |> String.codepoints() |> Enum.map(&card_order_map[&1])

      {t, v, String.to_integer(bid)}
    end)
    |> Enum.sort()
    |> Enum.with_index()
    |> Enum.map(fn {{_, _, bid}, idx} -> bid * (idx + 1) end)
    |> Enum.sum()
  end
end
