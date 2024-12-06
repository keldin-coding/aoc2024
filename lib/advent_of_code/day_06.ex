defmodule AdventOfCode.Day06 do
  import Coordinates

  @right_turns %{up: :right, right: :down, down: :left, left: :up}

  def part1(input) do
    data =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, ""))
      |> to_grid()

    grid = data[:grid]

    # Find where our robot is starting out
    starting_point = Enum.find(Map.keys(grid), &(grid[&1] == "^"))

    tiles_stepped_on =
      walk_robot_right_turns(grid, starting_point, :up, MapSet.new([starting_point]))

    MapSet.size(tiles_stepped_on)
  end

  def part2(input) do
    data =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, ""))
      |> to_grid()

    grid = data[:grid]

    nil
    # possible_new_grids =
  end

  defp walk_robot_right_turns(grid, current_position, direction, stepped_on) do
    next = next_position(current_position, direction)

    cond do
      grid[next] == "#" ->
        walk_robot_right_turns(grid, current_position, @right_turns[direction], stepped_on)

      # We've walked off the grid and are done
      !Map.has_key?(grid, next) ->
        stepped_on

      true ->
        walk_robot_right_turns(grid, next, direction, MapSet.put(stepped_on, next))
    end
  end

  defp next_position(current, :up), do: move_up(current)
  defp next_position(current, :down), do: move_down(current)
  defp next_position(current, :left), do: move_left(current)
  defp next_position(current, :right), do: move_right(current)
end
