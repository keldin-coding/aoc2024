defmodule AdventOfCodeTest do
  use ExUnit.Case

  test "list_of_lists_to_indexed_maps/1" do
    list = [
      ["a", "b", "c"],
      ["d", "e", "f"]
    ]

    expected = %{0 => %{0 => "a", 1 => "b", 2 => "c"}, 1 => %{0 => "d", 1 => "e", 2 => "f"}}

    assert expected == AdventOfCode.list_of_lists_to_indexed_maps(list)
  end
end
