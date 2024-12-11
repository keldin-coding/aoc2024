defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  import AdventOfCode.Day11

  @tag :day11
  @tag timeout: :infinity
  test "part1" do
    input = "125 17"
    result = with_integers(input, 6)

    assert 55312 == result
  end

  @tag :skip
  test "part2" do
    input = "125 17"
    result = part1(input, 75)

    assert result
  end
end
