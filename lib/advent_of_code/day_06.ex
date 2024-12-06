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

    # Find where our robot is starting out
    starting_point = Enum.find(Map.keys(grid), &(grid[&1] == "^"))

    possible_new_grids =
      Enum.reduce(Map.keys(grid), [], fn key, acc ->
        if grid[key] == "#" or grid[key] == "^" do
          acc
        else
          new_grid = Map.put(grid, key, "#")

          [{key, new_grid} | acc]
        end
      end)

    # {:ok, results_gatherer} = ResultsGatherer.start_link()

    possible_new_grids
    |> Enum.map(fn {_, obstructed_grid} ->
      Task.async(fn ->
        walk_robot_watch_for_cycles(obstructed_grid, starting_point, :up, 0, %{
          starting_point => [0]
        })
      end)
    end)
    |> Task.await_many(10_000)
    |> Enum.count(& &1)
  end

  defp walk_robot_watch_for_cycles(
         grid,
         current_position,
         direction,
         move_count,
         last_hit_for_position
       ) do
    next = next_position(current_position, direction)

    cond do
      grid[next] == "#" ->
        walk_robot_watch_for_cycles(
          grid,
          current_position,
          @right_turns[direction],
          move_count,
          last_hit_for_position
        )

      # We've walked off the grid and are done
      !Map.has_key?(grid, next) ->
        false

      true ->
        move_count = move_count + 1

        move_ids = Map.get(last_hit_for_position, next, [])
        move_ids = [move_count | move_ids]

        # We are being very cautious and requiring walking 2 loops minimum
        if length(move_ids) < 3 do
          walk_robot_watch_for_cycles(
            grid,
            next,
            direction,
            move_count,
            Map.put(last_hit_for_position, next, move_ids)
          )
        else
          [this_time, last_time, older_time | _] = move_ids

          # Same number of steps to get here twice
          this_time - last_time == last_time - older_time or
            walk_robot_watch_for_cycles(
              grid,
              next,
              direction,
              move_count,
              Map.put(last_hit_for_position, next, move_ids)
            )
        end
    end
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
