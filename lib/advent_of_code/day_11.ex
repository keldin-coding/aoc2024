defmodule AdventOfCode.Day11 do
  def part1(input, num_times \\ 25) do
    original_stones =
      input
      |> String.trim()
      |> String.split(" ", trim: true)

    1..num_times
    |> Enum.reduce({original_stones, %{"0" => "1"}}, fn _, {stones, outer_memory} ->
      Enum.reduce(stones, {[], outer_memory}, fn stone, {acc, memory} ->
        {result, memory} = evaluate_rules(stone, memory)

        if is_list(result) do
          {result ++ acc, memory}
        else
          {[result | acc], memory}
        end
      end)
    end)
    |> elem(0)
    |> length()
  end

  def with_integers(input, num_times \\ 25) do
    original_stones =
      input
      |> String.trim()
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)

    blink(%{stones: original_stones, count: length(original_stones)}, num_times)
  end

  defp blink(%{count: count}, 0), do: count

  defp blink(%{stones: stones, count: last_total}, times) do
    stones
    |> Enum.reduce(%{count: last_total, stones: []}, fn stone, %{count: count, stones: acc} ->
      result = evaluate_int_rule(stone)

      if is_list(result) do
        %{count: count + 1, stones: result ++ acc}
      else
        %{count: count, stones: [result | acc]}
      end
    end)
    |> blink(times - 1)
  end

  defp evaluate_int_rule(0), do: 1
  defp evaluate_int_rule(1), do: 2024

  defp evaluate_int_rule(stone) do
    log = :math.log10(stone)
    log_ceil = ceil(log)

    num_digits = if log_ceil == log, do: trunc(log) + 1, else: trunc(log_ceil)

    if rem(num_digits, 2) == 0 do
      half = trunc(:math.pow(10, num_digits / 2))
      [rem(stone, half), div(stone, half)]
    else
      stone * 2024
    end
  end

  defp evaluate_rules(stone, memory) when is_map_key(memory, stone),
    do: {Map.get(memory, stone), memory}

  defp evaluate_rules(stone, memory) do
    val = evaluate_rules(stone)

    {val, Map.put(memory, stone, val)}
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
