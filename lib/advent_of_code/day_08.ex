defmodule AdventOfCode.Day08 do
  import Coordinates

  def part1(input) do
    grid_data = convert_to_grid(input)

    grid = grid_data[:grid]

    grouped_by_antenna_type =
      grid
      |> Enum.filter(fn {_, antenna} -> String.match?(antenna, ~r/[a-zA-Z0-9]/) end)
      |> Enum.reduce(%{}, fn {c, antenna}, acc ->
        matching = Map.get(acc, antenna, [])

        Map.put(acc, antenna, [c | matching])
      end)

    grouped_by_antenna_type
    |> Enum.map(fn {_antenna_type, locations} ->
      locations
      |> Comb.combinations(2)
      |> Enum.map(&determine_antinodes/1)
    end)
    |> List.flatten()
    |> Enum.filter(fn location -> Map.get(grid, location, false) end)
    |> Enum.uniq()
    |> length()
  end

  def part2(input) do
    grid_data = convert_to_grid(input)

    grid = grid_data[:grid]

    grouped_by_antenna_type =
      grid
      |> Enum.filter(fn {_, antenna} -> String.match?(antenna, ~r/[a-zA-Z0-9]/) end)
      |> Enum.reduce(%{}, fn {c, antenna}, acc ->
        matching = Map.get(acc, antenna, [])

        Map.put(acc, antenna, [c | matching])
      end)

    grouped_by_antenna_type
    |> Enum.map(fn {_antenna_type, locations} ->
      if length(locations) >= 2 do
        locations
        |> Comb.combinations(2)
        |> Enum.map(&determine_antinodes_in_direction(grid, &1))
      else
        []
      end
    end)
    |> List.flatten()
    |> Enum.uniq()
    |> length()
  end

  def compute_diff({first_x, first_y}, {second_x, second_y}) do
    {second_x - first_x, second_y - first_y}
  end

  defp determine_antinodes([first, second]) do
    toward_second = compute_diff(first, second)
    toward_first = compute_diff(second, first)

    [
      move(first, toward_first),
      move(second, toward_second)
    ]
  end

  defp determine_antinodes_in_direction(grid, [first, second]) do
    toward_second = compute_diff(first, second)
    toward_first = compute_diff(second, first)

    [
      determine_antinodes_in_direction(grid, toward_first, first)
      | determine_antinodes_in_direction(grid, toward_second, second)
    ]
  end

  defp determine_antinodes_in_direction(grid, _, point) when not is_map_key(grid, point), do: []

  defp determine_antinodes_in_direction(grid, movement, point) do
    [point | determine_antinodes_in_direction(grid, movement, move(point, movement))]
  end

  defp convert_to_grid(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> to_grid()
  end
end
