defmodule AdventOfCode.Day09 do
  # The puzzle uses `.` to indicate free space, we're using -1

  def part1(input) do
    input
    |> split_input()
    |> create_fileblocks()
    |> defragment()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {val, index}, acc -> if val == -1, do: acc, else: acc + val * index end)
  end

  def part2(input) do
    input
    |> split_input()
    |> create_fileblock_chunks()
    |> defragment_in_chunks()
    |> Enum.flat_map(fn {val, how_many} -> List.duplicate(val, how_many) end)
    |> IO.inspect()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {val, index}, acc -> if val == -1, do: acc, else: acc + val * index end)
  end

  defp inspect_end_of_list(list) do
    list
    |> Enum.reverse()
    |> IO.inspect()
    |> Enum.reverse()
  end

  defp defragment_in_chunks(filemap_counts) do
    # filemap = :array.from_list(filemap_counts)

    defragment_in_chunks(
      # We can just exclude free slots from this data
      Enum.reverse(filemap_counts) |> Enum.filter(fn {v, _} -> v != -1 end),
      :array.from_list(filemap_counts)
    )
    |> :array.to_list()
  end

  # Should be []
  defp defragment_in_chunks(_, defragmented_filemap), do: defragmented_filemap

  defp defragment_in_chunks([{to_move_id, how_big_is_file} | rest], defragged) do
    current_slot =
      find_given_id(defragged, how_big_is_file, to_move_id, :array.size(defragged) - 1)

    valid_slot = find_given_id(defragged, how_big_is_file, -1, current_slot)

    if !valid_slot do
      defragment_in_chunks(rest, defragged)
    else
      defragged = move_data(defragged, valid_slot, current_slot)

      defragment_in_chunks(rest, defragged)
    end
  end

  defp move_data(defragged, index_to_replace, index_to_move) do
    # r_index = index_to_move + 1
    # l_index = index_to_move - 1

    # {l_data, l_size} = :array.get(l_index, defragged)

    # defragged = if l_data == -1 do

    # else
    #   defragged
    # end
  end

  defp find_given_id(_, _, _, before_index) when before_index == 0, do: nil

  # this is the worst named function on earth
  defp find_given_id(defragged, goal_size, given_id, before_index) do
    Enum.find(0..(before_index - 1), fn i ->
      {id, size} = :array.get(i, defragged)

      id == given_id and size >= goal_size
    end)
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

  def create_fileblock_chunks(filemap) do
    create_fileblock_chunks(filemap, :file, [])
  end

  defp create_fileblock_chunks([], _, acc), do: Enum.reverse(acc)

  defp create_fileblock_chunks([{current_num, current_id} | rest], :file, acc) do
    create_fileblock_chunks(rest, :free, [{Integer.floor_div(current_id, 2), current_num} | acc])
  end

  defp create_fileblock_chunks([{current_num, _} | rest], :free, acc) do
    create_fileblock_chunks(rest, :free, [{-1, current_num} | acc])
  end

  def split_input(input) do
    input
    |> String.trim()
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
  end
end
