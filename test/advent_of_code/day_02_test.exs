defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  test "part1" do
    input = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

    result = part1(input)

    assert 2 == result
  end

  test "part2" do
    input = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

    result = part2(input)

    assert 4 == result
  end

  @tag :only
  test "part2 more examples" do
    assert 0 == part2("75 75 72 69 66 65 64 65")

    assert 0 == part2("1 2 1 2 4")

    assert 1 == part2("75 75 72 69 66 65 64")
  end
end
