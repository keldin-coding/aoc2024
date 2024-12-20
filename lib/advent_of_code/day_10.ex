defmodule AdventOfCode.Day10 do
  import Coordinates

  def part1(input) do
    grid = gridify_input(input)
    trailheads = find_trailheads(grid)

    trailheads
    |> Enum.map(fn trailhead ->
      Task.async(fn ->
        paths_to_peaks(grid, trailhead)
      end)
    end)
    |> Task.await_many()
    |> Enum.map(&Enum.uniq/1)
    |> Enum.reduce(0, fn set, sum -> sum + length(set) end)
  end

  def part2(input) do
    grid = gridify_input(input)
    trailheads = find_trailheads(grid)

    trailheads
    |> Enum.map(fn trailhead ->
      Task.async(fn ->
        paths_to_peaks(grid, trailhead)
      end)
    end)
    |> Task.await_many()
    |> Enum.reduce(0, fn set, sum -> sum + length(set) end)
  end

  defp paths_to_peaks(grid, start) do
    paths_to_peaks(grid, move_up(start), 0, [])
    |> Enum.concat(paths_to_peaks(grid, move_right(start), 0, []))
    |> Enum.concat(paths_to_peaks(grid, move_down(start), 0, []))
    |> Enum.concat(paths_to_peaks(grid, move_left(start), 0, []))
  end

  # Walked off the edge, return what we have
  defp paths_to_peaks(grid, position, _, acc) when not is_map_key(grid, position), do: acc

  defp paths_to_peaks(grid, position, previous_value, acc) do
    value = Map.get(grid, position)

    cond do
      # We've reached a peak
      value == previous_value + 1 and value == 9 ->
        [position | acc]

      # We moved up by one at least
      value == previous_value + 1 ->
        acc
        |> Enum.concat(paths_to_peaks(grid, move_up(position), value, acc))
        |> Enum.concat(paths_to_peaks(grid, move_right(position), value, acc))
        |> Enum.concat(paths_to_peaks(grid, move_down(position), value, acc))
        |> Enum.concat(paths_to_peaks(grid, move_left(position), value, acc))

      true ->
        acc
    end
  end

  defp gridify_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, "", trim: true) |> Enum.map(&String.to_integer/1)
    end)
    |> to_grid()
    |> Map.get(:grid)
  end

  defp find_trailheads(grid) do
    grid
    |> Map.keys()
    |> Enum.filter(&(Map.get(grid, &1) == 0))
  end
end
