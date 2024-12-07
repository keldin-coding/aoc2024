defmodule AdventOfCode.Day07 do
  def part1(input) do
    input
    |> create_values_map()
    |> Enum.map(fn {target, [first | operands]} ->
      Task.async(fn ->
        results =
          [calculate(operands, target, :plus, first), calculate(operands, target, :mult, first)]
          |> List.flatten()

        {target, results}
      end)
    end)
    |> Task.await_many()
    |> Enum.filter(fn {target, results} -> Enum.any?(results, &(&1 == target)) end)
    |> Enum.reduce(0, fn {v, _}, acc -> acc + v end)
  end

  def part2(input) do
    input
    |> create_values_map()
    |> Enum.map(fn {target, [first | operands]} ->
      Task.async(fn ->
        results =
          [
            calculate_with_concat(operands, target, :plus, first),
            calculate_with_concat(operands, target, :mult, first),
            calculate_with_concat(operands, target, :concat, first)
          ]
          |> List.flatten()

        {target, results}
      end)
    end)
    |> Task.await_many()
    |> Enum.filter(fn {target, results} -> Enum.any?(results, &(&1 == target)) end)
    |> Enum.reduce(0, fn {v, _}, acc -> acc + v end)
  end

  # End of list, return result. Really shouldn't get here but.
  defp calculate(_, target, _, acc) when acc > target, do: -1

  defp calculate([last], _, :plus, acc), do: acc + last
  defp calculate([last], _, :mult, acc), do: acc * last

  defp calculate([current | operands], target, :plus, acc) do
    acc = acc + current
    [calculate(operands, target, :plus, acc), calculate(operands, target, :mult, acc)]
  end

  defp calculate([current | operands], target, :mult, acc) do
    acc = acc * current
    [calculate(operands, target, :plus, acc), calculate(operands, target, :mult, acc)]
  end

  # We failed, it's already too big
  defp calculate_with_concat(_, target, _, acc) when acc > target, do: -1

  # Last item
  defp calculate_with_concat([last], _, :plus, acc), do: acc + last
  defp calculate_with_concat([last], _, :mult, acc), do: acc * last
  defp calculate_with_concat([last], _, :concat, acc), do: concatenate_digits(acc, last)

  defp calculate_with_concat([current | operands], target, :plus, acc) do
    acc = acc + current

    [
      calculate_with_concat(operands, target, :plus, acc),
      calculate_with_concat(operands, target, :mult, acc),
      calculate_with_concat(operands, target, :concat, acc)
    ]
  end

  defp calculate_with_concat([current | operands], target, :mult, acc) do
    acc = acc * current

    [
      calculate_with_concat(operands, target, :plus, acc),
      calculate_with_concat(operands, target, :mult, acc),
      calculate_with_concat(operands, target, :concat, acc)
    ]
  end

  defp calculate_with_concat([current | operands], target, :concat, acc) do
    acc = concatenate_digits(acc, current)

    [
      calculate_with_concat(operands, target, :plus, acc),
      calculate_with_concat(operands, target, :mult, acc),
      calculate_with_concat(operands, target, :concat, acc)
    ]
  end

  defp concatenate_digits(a, b) do
    "#{Integer.to_string(a)}#{Integer.to_string(b)}" |> String.to_integer()
  end

  defp create_values_map(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, acc ->
      [test_value, numbers] = String.split(line, ": ")
      test_value = String.to_integer(test_value)

      numbers = numbers |> String.split(" ") |> Enum.map(&String.to_integer/1)

      Map.put(acc, test_value, numbers)
    end)
  end
end
