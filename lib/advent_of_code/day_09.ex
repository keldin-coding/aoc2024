defmodule AdventOfCode.Day09 do
  # The puzzle uses `.` to indicate free space, we're using -1

  def part1(input) do
    input
    |> split_input()
    |> create_fileblocks()
    |> defragment()
    |> IO.inspect()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {val, index}, acc -> if val == -1, do: acc, else: acc + val * index end)
  end

  def part2(_args) do
  end

  defp inspect_end_of_list(list) do
    list
    |> Enum.reverse()
    |> Enum.reverse()
  end

  def defragment(fileblock_data) do
    # number_of_free_slots = Enum.count(fileblock_data, &(&1 == -1))
    fb_len = length(fileblock_data)

    defragment(
      Enum.with_index(fileblock_data),
      Enum.with_index(Enum.reverse(fileblock_data)),
      fb_len,
      []
    )
  end

  # We think we've moved everything, just tack the rest of the existing data onto the end
  defp defragment([{_, c_index} | _], [{last, last_index} | _], total_data, defragmented)
       when c_index + last_index >= total_data do
    if last != -1, do: Enum.reverse(defragmented), else: Enum.reverse([last | defragmented])
  end

  # defp defragment([{c, c_index} | _], [{_, last_index} | _], total_data, defragmented)
  #      when c_index + last_index + 1 > total_data do
  #   Enum.reverse([c | defragmented])
  # end

  # Current slot is data
  defp defragment([{c, _} | ordered_data], backwards, total_data, defragmented) when c != -1,
    do: defragment(ordered_data, backwards, total_data, [c | defragmented])

  # Current slot is free and last slot is data
  defp defragment([{c, _} | ordered_data], [{last, _} | backwards], total_data, defragmented)
       when c == -1 and last != -1 do
    defragment(ordered_data, backwards, total_data, [last | defragmented])
  end

  # Current slot is free and last slot is free
  defp defragment(
         [{c, c_index} | ordered_data],
         [{last, _} | backwards],
         total_data,
         defragmented
       )
       when c == -1 and last == -1 do
    defragment([{c, c_index} | ordered_data], backwards, total_data, defragmented)
  end

  def create_fileblocks(diskmap), do: create_fileblocks(diskmap, :file, [])

  defp create_fileblocks([], _, file_data), do: Enum.reverse(file_data)

  defp create_fileblocks([{current_num, current_id} | rest], :file, file_data) do
    create_fileblocks(
      rest,
      :free,
      List.duplicate(Integer.floor_div(current_id, 2), current_num) ++ file_data
    )
  end

  defp create_fileblocks([{current_num, _} | rest], :free, file_data) do
    create_fileblocks(
      rest,
      :file,
      List.duplicate(-1, current_num) ++ file_data
    )
  end

  def split_input(input) do
    input
    |> String.trim()
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
  end
end
