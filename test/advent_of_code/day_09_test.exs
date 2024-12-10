defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  import AdventOfCode.Day09

  @tag :day9
  test "part1" do
    input = "2333133121414131402"
    result = part1(input)

    assert 1928 == result
  end

  @tag :day9
  test "create_fileblocks/1" do
    input = "2333133121414131402"

    result = create_fileblocks(split_input(input))

    result_as_str =
      result
      |> Enum.map(fn i -> if i == -1, do: ".", else: "#{i}" end)
      |> Enum.join("")

    assert "00...111...2...333.44.5555.6666.777.888899" == result_as_str
  end

  # Temp test
  @tag :day9
  test "defragment" do
    input = "12345"

    result =
      input
      |> split_input()
      |> create_fileblocks()
      |> defragment()

    result_as_str =
      result
      |> Enum.map(fn i -> if i == -1, do: ".", else: "#{i}" end)
      |> Enum.join("")

    assert "022111222." == result_as_str

    input = "2333133121414131402"

    result =
      input
      |> split_input()
      |> create_fileblocks()
      |> defragment()

    result_as_str =
      result
      |> Enum.map(fn i -> if i == -1, do: ".", else: "#{i}" end)
      |> Enum.join("")

    assert "0099811188827773336446555566" == result_as_str
  end

  @tag :day9
  test "part2" do
    input = "2333133121414131402"
    result = part2(input)

    assert 2858 == result
  end
end
