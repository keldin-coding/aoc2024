defmodule CoordinatesTest do
  use ExUnit.Case

  import Coordinates

  test "to_grid/1" do
    input = [
      ["a", "b", "c"],
      ["d", "e", "f"],
      ["g", "h", "i"]
    ]

    expected_map = %{
      grid: %{
        {0, 0} => "a",
        {1, 0} => "b",
        {2, 0} => "c",
        {0, 1} => "d",
        {1, 1} => "e",
        {2, 1} => "f",
        {0, 2} => "g",
        {1, 2} => "h",
        {2, 2} => "i"
      },
      max_width: 3,
      max_height: 3
    }

    assert expected_map == to_grid(input)
  end

  test "move_up/1" do
    assert {2, 1} == move_up({2, 2})
  end

  test "move_down/1" do
    assert {2, 3} == move_down({2, 2})
  end

  test "move_left/1" do
    assert {4, 5} == move_left({5, 5})
  end

  test "move_right/1" do
    assert {6, 5} == move_right({5, 5})
  end

  test "move/2" do
    assert {12, 15} == move({5, 5}, {7, 10})
    assert {3, 3} == move({5, 5}, {-2, -2})
  end
end
