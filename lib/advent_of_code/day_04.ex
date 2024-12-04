defmodule AdventOfCode.Day04 do
  @forward_next_letter %{"X" => "M", "M" => "A", "A" => "S", "S" => nil}
  @backward_next_letter %{"S" => "A", "A" => "M", "M" => "X", "X" => nil}

  import Coordinates

  def part1(input) do
    full_search =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Coordinates.to_grid()

    full_search[:grid]
    |> Map.keys()
    |> Enum.reduce(0, fn coord, sum ->
      letter = full_search[:grid][coord]

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
    full_search_data =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Coordinates.to_grid()

    matches_mas? = fn pair -> pair == {"M", "S"} or pair == {"S", "M"} end

    full_search = full_search_data[:grid]

    full_search
    |> Map.keys()
    |> Enum.reduce(0, fn coords, sum ->
      letter = full_search[coords]

      if letter != "A" do
        sum
      else
        diag_down_letters =
          {full_search[move_left(move_up(coords))], full_search[move_right(move_down(coords))]}

        diag_up_letters =
          {full_search[move_left(move_down(coords))], full_search[move_right(move_up(coords))]}

        sum +
          if(matches_mas?.(diag_down_letters) and matches_mas?.(diag_up_letters), do: 1, else: 0)
      end
    end)
  end

  # current_pos is a two item tuple {row, col}
  defp check_horizontal_forwards?(%{grid: word_search} = search_data, coord, count) do
    current_letter = word_search[coord]

    if is_nil(current_letter) do
      false
    else
      next_required = @forward_next_letter[current_letter]
      next_coord = move_right(coord)

      (is_nil(next_required) and count == 4) or
        (word_search[next_coord] == next_required and
           check_horizontal_forwards?(search_data, next_coord, count + 1))
    end
  end

  defp check_horizontal_backwards?(%{grid: word_search} = search_data, coord, count) do
    current_letter = word_search[coord]

    if is_nil(current_letter) do
      false
    else
      next_required = @backward_next_letter[current_letter]
      next_coord = move_right(coord)

      (is_nil(next_required) and count == 4) or
        (word_search[next_coord] == next_required and
           check_horizontal_backwards?(search_data, next_coord, count + 1))
    end
  end

  defp check_vertical_forwards?(%{grid: word_search} = search_data, coord, count) do
    current_letter = word_search[coord]

    if is_nil(current_letter) do
      false
    else
      next_required = @forward_next_letter[current_letter]
      next_coord = move_down(coord)

      (is_nil(next_required) and count == 4) or
        (word_search[next_coord] == next_required and
           check_vertical_forwards?(search_data, next_coord, count + 1))
    end
  end

  defp check_vertical_backwards?(%{grid: word_search} = search_data, coord, count) do
    current_letter = word_search[coord]

    if is_nil(current_letter) do
      false
    else
      next_required = @backward_next_letter[current_letter]
      next_coord = move_down(coord)

      (is_nil(next_required) and count == 4) or
        (word_search[next_coord] == next_required and
           check_vertical_backwards?(search_data, next_coord, count + 1))
    end
  end

  defp check_diagonal_up_forwards?(%{grid: word_search} = search_data, coord, count) do
    current_letter = word_search[coord]

    if is_nil(current_letter) do
      false
    else
      next_required = @forward_next_letter[current_letter]
      next_coord = coord |> move_up() |> move_right()

      (is_nil(next_required) and count == 4) or
        (word_search[next_coord] == next_required and
           check_diagonal_up_forwards?(search_data, next_coord, count + 1))
    end
  end

  defp check_diagonal_down_forwards?(%{grid: word_search} = search_data, coord, count) do
    current_letter = word_search[coord]

    if is_nil(current_letter) do
      false
    else
      next_required = @forward_next_letter[current_letter]
      next_coord = coord |> move_down() |> move_right()

      (is_nil(next_required) and count == 4) or
        (word_search[next_coord] == next_required and
           check_diagonal_down_forwards?(search_data, next_coord, count + 1))
    end
  end

  defp check_diagonal_up_backwards?(%{grid: word_search} = search_data, coord, count) do
    current_letter = word_search[coord]

    if is_nil(current_letter) do
      false
    else
      next_required = @backward_next_letter[current_letter]
      next_coord = coord |> move_up() |> move_right()

      (is_nil(next_required) and count == 4) or
        (word_search[next_coord] == next_required and
           check_diagonal_up_backwards?(search_data, next_coord, count + 1))
    end
  end

  defp check_diagonal_down_backwards?(%{grid: word_search} = search_data, coord, count) do
    current_letter = word_search[coord]

    if is_nil(current_letter) do
      false
    else
      next_required = @backward_next_letter[current_letter]
      next_coord = coord |> move_down() |> move_right()

      (is_nil(next_required) and count == 4) or
        (word_search[next_coord] == next_required and
           check_diagonal_down_backwards?(search_data, next_coord, count + 1))
    end
  end
end
