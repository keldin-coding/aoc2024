defmodule AdventOfCode.Day11 do
  defmodule Counter do
    def new(), do: %{}

    def add(counter, value, amount \\ 1),
      do: Map.put(counter, value, Map.get(counter, value, 0) + amount)

    def merge(counter, other) do
      Map.merge(counter, other, fn _, val1, val2 -> val1 + val2 end)
    end
  end

  # Much obliged to https://www.reddit.com/r/adventofcode/comments/1hbm0al/comment/m28g1zv/
  # courtesy of u/zniperr
  def solve(input, num_times \\ 25) do
    original_stones =
      input
      |> String.trim()
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)

    initial = Enum.reduce(original_stones, Counter.new(), fn i, acc -> Counter.add(acc, i) end)

    blink(initial, num_times)
    |> Enum.reduce(0, fn {_, occurrences}, sum -> sum + occurrences end)
  end

  def blink(counts, 0), do: counts

  def blink(counts, times) do
    new_counts =
      Enum.reduce(counts, Counter.new(), fn {stone, occurrences}, acc ->
        Counter.merge(
          acc,
          Enum.reduce(
            List.wrap(evaluate_int_rule(stone)),
            Counter.new(),
            &Counter.add(&2, &1, occurrences)
          )
        )
      end)

    blink(new_counts, times - 1)
  end

  def evaluate_int_rule(0), do: 1
  def evaluate_int_rule(1), do: 2024

  def evaluate_int_rule(stone) do
    log = :math.log10(stone)
    log_ceil = ceil(log)

    num_digits = if log_ceil == log, do: trunc(log) + 1, else: trunc(log_ceil)

    if rem(num_digits, 2) == 0 do
      half = trunc(:math.pow(10, num_digits / 2))
      [div(stone, half), rem(stone, half)]
    else
      stone * 2024
    end
  end
end
