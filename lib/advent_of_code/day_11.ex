defmodule AdventOfCode.Day11 do
  def part1(input, num_times \\ 25) do
    original_stones =
      input
      |> String.trim()
      |> String.split(" ", trim: true)

    1..num_times
    |> Enum.reduce(original_stones, fn _, stones ->
      Enum.reduce(stones, [], fn stone, acc ->
        result = evaluate_rules(stone)

        if is_list(result) do
          result ++ acc
        else
          [result | acc]
        end
      end)
    end)
    |> length()
  end

  defp evaluate_rules("0"), do: "1"

  defp evaluate_rules(stone) when rem(byte_size(stone), 2) == 0 do
    half_size = div(byte_size(stone), 2)

    first_half = binary_part(stone, 0, half_size)
    second_half = binary_part(stone, half_size, half_size) |> String.trim_leading("0")

    second_half = if second_half == "", do: "0", else: second_half

    [first_half, second_half]
  end

  defp evaluate_rules(stone) do
    stone = String.to_integer(stone)

    stone = stone * 2024

    "#{stone}"
  end

  def part2(input, num_times \\ 75) do
    original_stones =
      input
      |> String.trim()
      |> String.split(" ", trim: true)

    1..num_times
    |> Enum.reduce(original_stones, fn _, stones ->
      stones
      |> Enum.chunk_every(500)
      |> Enum.map(fn chunk ->
        Task.async(fn ->
          Enum.map(
            chunk,
            &List.wrap(evaluate_rules(&1))
          )
        end)
      end)
      |> Task.await_many()
      |> List.flatten()
    end)
    |> length()
  end
end
