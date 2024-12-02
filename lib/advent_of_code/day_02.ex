defmodule AdventOfCode.Day02 do
  def part1(input) do
    input
    |> process()
    |> Enum.count(fn report -> safe_report?(report) end)
  end

  def part2(input) do
    input
    |> process()
    |> Enum.count(fn report -> tolerable_safe_report?(report) end)
  end

  defp process(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn i ->
      i |> String.trim() |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
    end)
  end

  defp safe_report?(list), do: safe_report?(list, 0)

  defp safe_report?([_], _), do: true

  defp safe_report?([first, second | rest], prev_direction) do
    change = second - first

    # This technically misses where it's 0, but we catch it in the cond
    direction_of_change = if change > 0, do: 1, else: -1

    cond do
      # Neither increasing nor decreasing
      change == 0 ->
        false

      # Changing by more than 3
      abs(change) > 3 ->
        false

      # Previous diff and this change do not match signs
      prev_direction != 0 and direction_of_change != prev_direction ->
        false

      true ->
        safe_report?([second | rest], direction_of_change)
    end
  end

  @spec tolerable_safe_report?(list(integer())) :: boolean()
  defp tolerable_safe_report?(report) do
    if safe_report?(report, 0) do
      true
    else
      permutations = length(report)

      0..(permutations - 1)
      |> Enum.map(fn i ->
        {_, removed} = List.pop_at(report, i)
        removed
      end)
      |> Enum.any?(fn report -> safe_report?(report, 0) end)
    end
  end
end
