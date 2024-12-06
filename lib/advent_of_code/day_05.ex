defmodule AdventOfCode.Day05 do
  def part1(input) do
    {page_sets, update_reqs} = pages_and_orderings(input)

    # IO.inspect(page_sets, label: "Page sets", charlists: :as_lists)
    # IO.inspect(update_reqs, label: "Update lists", charlists: :as_lists)

    # correct_orders =
    update_reqs
    |> Enum.filter(&required_page_orders?(&1, [], page_sets))
    |> Enum.map(fn pages ->
      midpoint = Integer.floor_div(length(pages), 2)
      Enum.at(pages, midpoint)
    end)
    |> Enum.reduce(0, &(&1 + &2))
  end

  def part2(input) do
    {page_sets, update_reqs} = pages_and_orderings(input)

    incorrect_orders =
      update_reqs
      |> Enum.filter(&(!required_page_orders?(&1, [], page_sets)))

    order_reqs = Enum.map(incorrect_orders, &determine_order_requirements(&1, page_sets))

    sort_orders(incorrect_orders, order_reqs, [])
    |> Enum.map(fn pages ->
      midpoint = Integer.floor_div(length(pages), 2)
      Enum.at(pages, midpoint)
    end)
    |> Enum.sum()
  end

  defp determine_order_requirements(pages, {required_to_target, target_to_required}) do
    pages
    |> Enum.reduce({%{}, %{}}, fn page, {r, t} ->
      must_come_after =
        Map.get(required_to_target, page, []) |> Enum.filter(&Enum.member?(pages, &1))

      must_come_before =
        Map.get(target_to_required, page, []) |> Enum.filter(&Enum.member?(pages, &1))

      {Map.put(r, page, must_come_after), Map.put(t, page, must_come_before)}
    end)
  end

  defp sort_orders([], [], acc), do: acc

  # By I'm assuming unwritten design, all page numbers listed
  # are also in the requirements. I'm also probably a little lucky there
  # isn't a case where there's two numbers that rely on 3 each and one of them
  # overlaps so their individual order matters.
  defp sort_orders([_ | rest], [requirements | rest_reqs], acc) do
    {_, target_to_required} = requirements

    by_most_required =
      target_to_required
      |> Enum.to_list()
      |> Enum.sort_by(fn {_, v} -> length(v) end)
      |> Enum.map(fn {page, _} -> page end)

    sort_orders(rest, rest_reqs, [by_most_required | acc])
  end

  defp pages_and_orderings(input) do
    [page_sets, update_reqs] = String.split(input, "\n\n")

    page_sets =
      page_sets
      |> String.split("\n", trim: true)
      |> Enum.map(fn i ->
        [a, b] = String.split(i, "|")
        {String.to_integer(a), String.to_integer(b)}
      end)

    target_to_required =
      Enum.reduce(page_sets, %{}, fn {required, target}, acc ->
        set = Map.get(acc, target, [])
        Map.put(acc, target, [required | set])
      end)

    required_to_targets =
      Enum.reduce(page_sets, %{}, fn {required, target}, acc ->
        set = Map.get(acc, required, [])
        Map.put(acc, required, [target | set])
      end)

    # Update requirements are just a list of lists
    update_reqs =
      update_reqs
      |> String.split("\n", trim: true)
      |> Enum.map(fn i ->
        i |> String.split(",") |> Enum.map(&String.to_integer/1)
      end)

    {{required_to_targets, target_to_required}, update_reqs}
  end

  # A given page number is valid IFF:
  #   * It is not in a pair of predecessor|target, OR
  #   * only one half of the pair appears, OR
  #   * Any numbers previously seen are either unmatched or appear before it in its pair, OR
  #   * No numbers previously seen are on the right hand side of the pair
  defp required_page_orders?([], _, _), do: true

  defp required_page_orders?(
         [h | rest],
         previous,
         {required_to_target, target_to_required} = sets
       )
       when not is_map_key(required_to_target, h) and
              not is_map_key(target_to_required, h),
       do: required_page_orders?(rest, [h | previous], sets)

  defp required_page_orders?(
         [h | rest],
         previous,
         {required_to_target, _} = sets
       ) do
    # must_have_already_seen = Map.get(target_to_required, h, []) |> Enum.filter?(&Enum.member?(previous, &1))
    cannot_have_already_seen = Map.get(required_to_target, h, [])

    # If we have X|h, make sure none of X have been seen
    !Enum.any?(cannot_have_already_seen, &Enum.member?(previous, &1)) and
      required_page_orders?(rest, [h | previous], sets)
  end
end
