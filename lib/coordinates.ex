defmodule Coordinates do
  @type coordinate :: {integer(), integer()}

  @doc """
  Creates a Map of coordinates from a 2-d list of lists, centered on a 0,0 as
  the "upper left" corner, with x growing to the RIGHT and y growing as we go
  DOWN the grid, pixel style.
  Do not use if your origin is elsewhere.
  """
  @spec to_grid(list(list(any()))) :: %{{integer(), integer()} => any()}
  def to_grid([h | _] = lists) when is_list(h) do
    grid =
      lists
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {data, row_num}, outer_acc ->
        row_data =
          data
          |> Enum.with_index()
          |> Enum.reduce(%{}, fn {item, col_num}, acc ->
            Map.put(acc, {col_num, row_num}, item)
          end)

        Map.merge(outer_acc, row_data)
      end)

    {width, height} = grid |> Map.keys() |> Enum.max()

    %{max_width: width + 1, max_height: height + 1, grid: grid}
  end

  @spec move_up({integer(), integer()}) :: {integer(), integer()}
  def move_up({x, y}) when is_integer(x) and is_integer(y), do: {x, y - 1}

  @spec move_down({integer(), integer()}) :: {integer(), integer()}
  def move_down({x, y}) when is_integer(x) and is_integer(y), do: {x, y + 1}

  @spec move_left({integer(), integer()}) :: {integer(), integer()}
  def move_left({x, y}) when is_integer(x) and is_integer(y), do: {x - 1, y}

  @spec move_right({integer(), integer()}) :: {integer(), integer()}
  def move_right({x, y}) when is_integer(x) and is_integer(y), do: {x + 1, y}
end
