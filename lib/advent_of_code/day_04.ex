defmodule AdventOfCode.Day04 do
  @forward_next_letter %{"X" => "M", "M" => "A", "A" => "S", "S" => nil}
  @backward_next_letter %{"S" => "A", "A" => "M", "M" => "X", "X" => nil}

  def part1(input) do
    full_search = split_up_into_indexed_maps(input)

    row_nums = 0..(length(Map.keys(full_search)) - 1)
    col_nums = 0..(length(Map.keys(full_search[0])) - 1)

    coordinates =
      row_nums
      |> Enum.map(fn row_num -> Enum.map(col_nums, &{row_num, &1}) end)
      |> List.flatten()

    coordinates
    |> Enum.reduce(0, fn {row, col} = coord, sum ->
      letter = full_search[row][col]

      case letter do
        "X" ->
          sum + if(check_horizontal_forwards?(full_search, coord, 1), do: 1, else: 0) +
            if(check_vertical_forwards?(full_search, coord, 1), do: 1, else: 0) +
            if(check_diagonal_up_forwards?(full_search, coord, 1), do: 1, else: 0) +
            if(check_diagonal_down_forwards?(full_search, coord, 1), do: 1, else: 0)

        "S" ->
          sum + if(check_horizontal_backwards?(full_search, coord, 1), do: 1, else: 0) +
            if(check_vertical_backwards?(full_search, coord, 1), do: 1, else: 0) +
            if(check_diagonal_up_backwards?(full_search, coord, 1), do: 1, else: 0) +
            if(check_diagonal_down_backwards?(full_search, coord, 1), do: 1, else: 0)

        _ ->
          sum
      end
    end)
  end

  def part2(input) do
    full_search = split_up_into_indexed_maps(input)

    row_nums = 0..(length(Map.keys(full_search)) - 1)
    col_nums = 0..(length(Map.keys(full_search[0])) - 1)

    matches_mas? = fn pair -> pair == {"M", "S"} or pair == {"S", "M"} end

    coordinates =
      row_nums
      |> Enum.map(fn row_num -> Enum.map(col_nums, &{row_num, &1}) end)
      |> List.flatten()

    coordinates
    |> Enum.reduce(0, fn {row, col} = {row, col}, sum ->
      letter = full_search[row][col]

      if letter != "A" do
        sum
      else
        diag_down_letters = {full_search[row - 1][col - 1], full_search[row + 1][col + 1]}
        diag_up_letters = {full_search[row + 1][col - 1], full_search[row - 1][col + 1]}

        sum +
          if(matches_mas?.(diag_down_letters) and matches_mas?.(diag_up_letters), do: 1, else: 0)
      end
    end)
  end

  defp split_up_into_indexed_maps(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> AdventOfCode.list_of_lists_to_indexed_maps()
  end

  # current_pos is a two item tuple {row, col}
  defp check_horizontal_forwards?(word_search, {row, col}, count) do
    if col >= length(Map.keys(word_search[row])) do
      false
    else
      current_letter = word_search[row][col]
      next_required = @forward_next_letter[current_letter]

      # IO.inspect({row, col})

      (is_nil(next_required) and count == 4) or
        (word_search[row][col + 1] == next_required and
           check_horizontal_forwards?(word_search, {row, col + 1}, count + 1))
    end
  end

  defp check_horizontal_backwards?(word_search, {row, col}, count) do
    if col >= length(Map.keys(word_search[row])) do
      false
    else
      current_letter = word_search[row][col]
      next_required = @backward_next_letter[current_letter]

      # IO.puts("Current: #{current_letter}, expected #{next_required}, count: #{count}")
      # IO.inspect({row, col})

      (is_nil(next_required) and count == 4) or
        (word_search[row][col + 1] == next_required and
           check_horizontal_backwards?(word_search, {row, col + 1}, count + 1))
    end
  end

  defp check_vertical_forwards?(word_search, {row, col}, count) do
    if row >= length(Map.keys(word_search)) do
      false
    else
      current_letter = word_search[row][col]
      next_required = @forward_next_letter[current_letter]

      # IO.puts("Current: #{current_letter}, expected #{next_required}, count: #{count}")

      # IO.inspect({row, col})

      (is_nil(next_required) and count == 4) or
        (word_search[row + 1][col] == next_required and
           check_vertical_forwards?(word_search, {row + 1, col}, count + 1))
    end
  end

  defp check_vertical_backwards?(word_search, {row, col}, count) do
    if row >= length(Map.keys(word_search)) do
      false
    else
      current_letter = word_search[row][col]
      next_required = @backward_next_letter[current_letter]

      # IO.puts("Current: #{current_letter}, expected #{next_required}, count: #{count}")

      # IO.inspect({row, col})

      (is_nil(next_required) and count == 4) or
        (word_search[row + 1][col] == next_required and
           check_vertical_backwards?(word_search, {row + 1, col}, count + 1))
    end
  end

  defp check_diagonal_up_forwards?(word_search, {row, col}, count) do
    if row < 0 or col >= length(Map.keys(word_search[row])) do
      false
    else
      current_letter = word_search[row][col]
      next_required = @forward_next_letter[current_letter]

      # IO.puts("Current: #{current_letter}, expected #{next_required}, count: #{count}")

      # IO.inspect({row, col})

      (is_nil(next_required) and count == 4) or
        (word_search[row - 1][col + 1] == next_required and
           check_diagonal_up_forwards?(word_search, {row - 1, col + 1}, count + 1))
    end
  end

  defp check_diagonal_down_forwards?(word_search, {row, col}, count) do
    if row >= length(Map.keys(word_search)) or col >= length(Map.keys(word_search[row])) do
      false
    else
      current_letter = word_search[row][col]
      next_required = @forward_next_letter[current_letter]

      # IO.puts("Current: #{current_letter}, expected #{next_required}, count: #{count}")

      # IO.inspect({row, col})

      (is_nil(next_required) and count == 4) or
        (word_search[row + 1][col + 1] == next_required and
           check_diagonal_down_forwards?(word_search, {row + 1, col + 1}, count + 1))
    end
  end

  defp check_diagonal_up_backwards?(word_search, {row, col}, count) do
    if row < 0 or row >= length(Map.keys(word_search)) or
         col >= length(Map.keys(word_search[row])) do
      false
    else
      current_letter = word_search[row][col]
      next_required = @backward_next_letter[current_letter]

      # IO.puts("Current: #{current_letter}, expected #{next_required}, count: #{count}")

      # IO.inspect({row, col})

      (is_nil(next_required) and count == 4) or
        (word_search[row - 1][col + 1] == next_required and
           check_diagonal_up_backwards?(word_search, {row - 1, col + 1}, count + 1))
    end
  end

  defp check_diagonal_down_backwards?(word_search, {row, col}, count) do
    if row < 0 or row >= length(Map.keys(word_search)) or
         col >= length(Map.keys(word_search[row])) do
      false
    else
      current_letter = word_search[row][col]
      next_required = @backward_next_letter[current_letter]

      # IO.puts("Current: #{current_letter}, expected #{next_required}, count: #{count}")

      # IO.inspect({row, col})

      (is_nil(next_required) and count == 4) or
        (word_search[row + 1][col + 1] == next_required and
           check_diagonal_down_backwards?(word_search, {row + 1, col + 1}, count + 1))
    end
  end
end
