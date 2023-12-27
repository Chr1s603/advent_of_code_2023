defmodule AdventOfCode2023.Day16 do
  alias AdventOfCode2023.General

  def task1 do
    {map, map_w, map_h} = load_map()

    start_last = {-1, map_h - 1}
    start_current = {0, map_h - 1}
    get_max_lighted([{start_current, start_last}], map, map_w, map_h)
  end

  def task2 do
    {map, map_w, map_h} = load_map()

    low = 0..(map_w - 1) |> Enum.reduce([], &(&2 ++ [{{&1, 0}, {&1, -1}}]))
    up = 0..(map_w - 1) |> Enum.reduce([], &(&2 ++ [{{&1, map_h - 1}, {&1, map_h}}]))
    left = 0..(map_h - 1) |> Enum.reduce([], &(&2 ++ [{{0, &1}, {-1, &1}}]))
    right = 0..(map_h - 1) |> Enum.reduce([], &(&2 ++ [{{map_w - 1, &1}, {map_w, &1}}]))

    get_max_lighted(low ++ up ++ left ++ right, map, map_w, map_h)
  end

  defp get_max_lighted(starts, map, map_w, map_h) do
    Enum.map(starts, fn {start_current, start_last} ->
      mark_all_lighted([start_current], [start_last], map, map_w, map_h, [], [])
      |> Enum.count()
    end)
    |> Enum.max()
  end

  defp load_map do
    raw =
      File.stream!("data/day16.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_charlist/1)

    width = Enum.count(Enum.at(raw, 0))
    height = Enum.count(raw)

    map =
      raw
      |> Enum.reduce({Map.new(), height - 1}, fn line, {map, y} ->
        {Enum.reduce(line, {map, 0}, fn char, {acc, x} ->
           {Map.merge(acc, %{{x, y} => char}), x + 1}
         end), y - 1}
        |> then(fn {{m, _x}, y} -> {m, y} end)
      end)
      |> Tuple.to_list()
      |> Enum.at(0)

    {map, width, height}
  end

  defp get_next_positions(current_pos, last_pos, map) do
    {cx, cy} = current_pos
    {lx, ly} = last_pos
    x_diff = cx - lx
    y_diff = cy - ly

    Map.fetch!(map, current_pos)
    |> case do
      ?. ->
        [{cx + x_diff, cy + y_diff}]

      ?- ->
        if x_diff != 0 do
          [{cx + x_diff, cy}]
        else
          [{cx - 1, cy}, {cx + 1, cy}]
        end

      ?| ->
        if y_diff != 0 do
          [{cx, cy + y_diff}]
        else
          [{cx, cy - 1}, {cx, cy + 1}]
        end

      ?/ ->
        if x_diff > 0 do
          [{cx, cy + 1}]
        else
          if x_diff < 0 do
            [{cx, cy - 1}]
          else
            if y_diff > 0 do
              [{cx + 1, cy}]
            else
              [{cx - 1, cy}]
            end
          end
        end

      92 ->
        if x_diff > 0 do
          [{cx, cy - 1}]
        else
          if x_diff < 0 do
            [{cx, cy + 1}]
          else
            if y_diff > 0 do
              [{cx - 1, cy}]
            else
              [{cx + 1, cy}]
            end
          end
        end
    end
  end

  defp reject_invalid_postions(positions, map_w, map_h) do
    Enum.reject(positions, fn {x, y} ->
      x < 0 or y < 0 or x >= map_w or y >= map_h
    end)
  end

  defp mark_all_lighted([cp | rcps], [lp | rlps], map, map_w, map_h, marked, visited) do
    if Enum.member?(visited, {cp, lp}) do
      mark_all_lighted(rcps, rlps, map, map_w, map_h, marked, visited)
    else
      next = get_next_positions(cp, lp, map) |> reject_invalid_postions(map_w, map_h)

      cps = if rcps != nil, do: next ++ rcps, else: next

      lps =
        if rlps != nil,
          do: List.duplicate(cp, Enum.count(next)) ++ rlps,
          else: List.duplicate(cp, Enum.count(next))

      mark_all_lighted(
        cps,
        lps,
        map,
        map_w,
        map_h,
        General.add_if_not_present(marked, cp),
        [{cp, lp}] ++ visited
      )
    end
  end

  defp mark_all_lighted([], [], _map, _map_w, _map_h, marked, _visited), do: marked
end
