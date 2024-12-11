defmodule AdventOfCode.Day10Test do
  use ExUnit.Case

  import AdventOfCode.Day10

  @tag :day10
  test "part1" do
    input = """
    0123
    1234
    8765
    9876
    """

    assert 1 == part1(input)

    input = """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """

    result = part1(input)

    assert 36 == result
  end

  @tag :day10
  test "part2" do
    input = """
    0123
    1234
    8765
    9876
    """

    assert 16 == part2(input)

    input = """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """

    result = part2(input)

    assert 81 == result
  end
end
