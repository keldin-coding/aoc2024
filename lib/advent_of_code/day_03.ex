defmodule AdventOfCode.Day03 do
  def part1(input) do
    input
    |> extract_muls()
    |> Enum.reduce(0, fn [_, a, b], sum ->
      sum + String.to_integer(a) * String.to_integer(b)
    end)
  end

  def part2(input) do
    input
    |> combined_do_dont_mul_reg()
    |> sum_up(0, true)
  end

  defp extract_muls(input) do
    Regex.scan(~r/mul\((\d+),\s*(\d+)\)/, input)
  end

  defp combined_do_dont_mul_reg(input) do
    Regex.scan(~r/(mul\((\d+),\s*(\d+)\)|do\(\)|don't\(\))/, input)
  end

  defp sum_up([], sum, _), do: sum

  defp sum_up([["do()", _] | rest], sum, _active) do
    sum_up(rest, sum, true)
  end

  defp sum_up([["don't()", _] | rest], sum, _active) do
    sum_up(rest, sum, false)
  end

  defp sum_up([[_, _, a, b] | rest], sum, true) do
    sum_up(rest, sum + String.to_integer(a) * String.to_integer(b), true)
  end

  defp sum_up([_ | rest], sum, false) do
    sum_up(rest, sum, false)
  end
end
