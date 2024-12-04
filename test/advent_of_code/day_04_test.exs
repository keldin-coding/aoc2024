defmodule AdventOfCode.Day04Test do
  use ExUnit.Case

  import AdventOfCode.Day04

  test "part1" do
    input = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """

    result = part1(input)

    assert 18 == result
  end

  test "part1 second" do
    input = """
    ..X...
    .SAMX.
    .A..A.
    XMAS.S
    .X....
    """

    assert 4 == part1(input)
  end

  @tag :only
  test "part1 basics" do
    # Horizontal forwards
    # assert 1 == part1("MMXMASMM")

    # assert 2 ==
    #          part1("""
    #          XMAS
    #          XMAS
    #          """)

    # assert 0 == part1("XMAXMAXMA")

    # Horizontal Backwards
    # assert 1 == part1("SAMX")
    # assert 1 == part1("SSSSAMXXXX")
    # assert 1 == part1("XXXXX\nSAMX")

    # assert 3 ==
    #          part1("""
    #            XMAS
    #            XMAS
    #            SAMX
    #          """)

    # Vertical Forwards
    input = """
    X
    M
    A
    S
    """

    assert 1 == part1(input)

    input = """
    XX
    MM
    AA
    SS
    """

    assert 2 == part1(input)

    input = """
    XMASX
    MMMMM
    AAAAA
    SSSSS
    """

    assert 5 == part1(input)
  end

  test "part2" do
    input = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """

    result = part2(input)

    assert 9 == result
  end
end
