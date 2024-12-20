defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  @tag :day12
  @tag timeout: :infinity
  test "part1" do
    input = """
    AAAA
    BBCD
    BBCC
    EEEC
    """

    assert 140 == part1(input)

    input = """
    OOOOO
    OXOXO
    OOOOO
    OXOXO
    OOOOO
    """

    assert 772 == part1(input)

    input = """
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    """

    assert 1930 == part1(input)
  end

  @tag :day12
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
