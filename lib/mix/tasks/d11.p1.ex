defmodule Mix.Tasks.D11.P1 do
  use Mix.Task

  import AdventOfCode.Day11

  @shortdoc "Day 11 Part 1"
  def run(args) do
    input = AdventOfCode.Input.get!(11, 2024)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> with_integers(25) end}),
      else:
        input
        |> with_integers(25)
        |> IO.inspect(label: "Part 1 Results")
  end
end
