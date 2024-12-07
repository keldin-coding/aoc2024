defmodule AdventOfCode.Day07Test do
  use ExUnit.Case

  import AdventOfCode.Day07

  @tag :day7
  test "part1" do
    input = """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    """

    # input = "190: 10 19"

    result = part1(input)

    assert 3749 == result
  end

  @tag :day7_small
  test "part1 small samples" do
    assert 2 == part1("2: 1 1")
    assert 3 == part1("3: 1 2 1")
  end

  @tag :day7
  test "part2" do
    input = """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    """

    result = part2(input)

    assert 11387 == result
  end

  @tag :day7
  test "part2 check for all concat" do
    input = """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    4455: 44 5 5
    """

    result = part2(input)

    assert 15842 == result
  end
end
