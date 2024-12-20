defmodule AdventOfCode.Day12 do
  import Coordinates

  def part1(input) do
    grid_data =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> to_grid()

    {regions, _} = contiguous_regions(grid_data)

    regions
    |> Enum.map(fn region -> {calculate_area(region), calculate_perimeter(region)} end)
  end

  def part2(input) do
  end

  defp calculate_area(region), do: length(region)

  defp calculate_perimter([_]), do: 4

  defp calculate_perimeter(region) do
  end

  defp contiguous_regions(grid_data) do
    grid = Map.get(grid_data, :grid)

    Map.keys(grid)
    |> Enum.reduce({[], %{}}, fn point, acc -> contiguous_regions(grid, point, acc) end)
  end

  defp contiguous_regions(_, point, {_, already_seen} = acc) when is_map_key(already_seen, point),
    do: acc

  defp contiguous_regions(grid, point, {regions, already_seen}) do
    plant = Map.get(grid, point)

    current_region = contiguous_regions(grid, point, plant, [])

    already_seen =
      Enum.reduce(current_region, already_seen, fn i, acc -> Map.put(acc, i, true) end)

    {[current_region | regions], already_seen}
  end

  defp contiguous_regions(grid, point, _, acc) when not is_map_key(grid, point), do: acc

  defp contiguous_regions(grid, point, plant, acc) do
    if Map.get(grid, point) == plant and !Enum.member?(acc, point) do
      acc = [point | acc]

      [move_up(point), move_right(point), move_down(point), move_left(point)]
      |> Enum.reduce(acc, fn p, acc -> contiguous_regions(grid, p, plant, acc) end)
    else
      acc
    end
  end
end
