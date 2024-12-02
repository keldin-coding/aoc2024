defmodule AdventOfCode.Day01 do
  def part1(input) do
    {list_1, list_2} = process(input)

    sorted_1 = Enum.sort(list_1)
    sorted_2 = Enum.sort(list_2)

    zipped = Enum.zip(sorted_1, sorted_2)

    zipped
    |> Enum.reduce(0, fn {a, b}, acc -> acc + abs(b - a) end)
  end

  def part2(input) do
    {list_1, list_2} = process(input)

    list2_counts =
      Enum.reduce(list_2, %{}, fn num, acc ->
        val = Map.get(acc, num, 0)
        Map.put(acc, num, val + 1)
      end)

    list_1
    |> Enum.reduce(0, fn i, sum ->
      multiplier = Map.get(list2_counts, i, 0)

      sum + i * multiplier
    end)
  end

  defp process(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.reduce({[], []}, fn line, {list_1, list_2} ->
      [first, second] = String.split(line, " ", trim: true)
      {[String.to_integer(first) | list_1], [String.to_integer(second) | list_2]}
    end)
  end
end
