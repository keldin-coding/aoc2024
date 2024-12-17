defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  import AdventOfCode.Day11

  @tag :day11
  @tag timeout: :infinity
  test "part1" do
    input = "125 17"
    result = solve(input, 25)

    assert 55312 == result
  end

  @tag :skip
  test "part2" do
    input = "125 17"
    result = solve(input, 75)

    assert result
  end
end
