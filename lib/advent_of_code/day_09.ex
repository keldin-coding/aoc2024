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
    |> Enum.with_index()
    |> Enum.reduce(0, fn {val, index}, acc -> if val == -1, do: acc, else: acc + val * index end)
  end

  defp inspect_end_of_list(list) do
    list
    |> Enum.reverse()
    |> IO.inspect()
    |> Enum.reverse()
  end

  defp defragment_in_chunks(fileblocks) do
    complete_dataset =
      fileblocks
      |> Enum.flat_map(fn {val, how_many} -> List.duplicate(val, how_many) end)
      |> :array.from_list()

    fileblocks_with_data = fileblocks |> Enum.filter(fn {v, _} -> v != -1 end)

    indexed_data =
      Enum.reduce(
        fileblocks_with_data,
        %{list: [], previous: 0},
        fn {val, size}, %{list: list, previous: previous} ->
          index = index_for(complete_dataset, val, previous)

          %{
            list: [{val, size, index} | list],
            previous: index + size
          }
        end
      )

    fileblocks_with_data = indexed_data[:list]

    defragment_in_chunks(fileblocks_with_data, complete_dataset)
  end

  defp defragment_in_chunks([], complete_dataset), do: :array.to_list(complete_dataset)

  defp defragment_in_chunks([{value, size, value_index} | rest], dataset) do
    empty_slot = space_for(dataset, size, value_index, 0, nil)

    if empty_slot do
      dataset =
        dataset
        |> replace_with(value, empty_slot, size)
        |> replace_with(-1, value_index, size)

      defragment_in_chunks(rest, dataset)
    else
      defragment_in_chunks(rest, dataset)
    end
  end

  defp replace_with(dataset, _, _, 0), do: dataset

  defp replace_with(dataset, value, index, num) do
    dataset = :array.set(index, value, dataset)
    replace_with(dataset, value, index + 1, num - 1)
  end

  defp index_for(ary, search, start) do
    start..(:array.size(ary) - 1)
    |> Enum.find(fn i -> :array.get(i, ary) == search end)
  end

  defp space_for(ary, min_size, be_before, current_index, found_index) do
    val = :array.get(current_index, ary)

    cond do
      !is_nil(found_index) and current_index - found_index == min_size ->
        found_index

      be_before == current_index or val == :undefined ->
        nil

      val == -1 ->
        found_index = found_index || current_index

        space_for(ary, min_size, be_before, current_index + 1, found_index)

      val != -1 ->
        space_for(ary, min_size, be_before, current_index + 1, nil)
    end
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
    create_fileblock_chunks(rest, :file, [{-1, current_num} | acc])
  end

  def split_input(input) do
    input
    |> String.trim()
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
  end
end
