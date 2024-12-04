defmodule AdventOfCode do
  @moduledoc """
  Documentation for AdventOfCode.
  """

  def list_of_lists_to_indexed_maps(lists) do
    lists
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {data, row_num}, outer_acc ->
      row_data =
        data
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {item, col_num}, acc ->
          Map.put(acc, col_num, item)
        end)

      Map.put(outer_acc, row_num, row_data)
    end)
  end
end
