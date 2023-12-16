defmodule AdventOfCode2023.Day10 do
  def task1 do
    sketch = parse_sketch()
    start = get_start_pos(sketch)
    {start_x, start_y} = start

    # Checking 3 sides is enough as we always have 2 connections
    south = get_pipe_at(sketch, {start_x, start_y - 1})
    north = get_pipe_at(sketch, {start_x, start_y + 1})
    west = get_pipe_at(sketch, {start_x + 1, start_y})

    overall_track_len =
      if south == :ns or south == :ne or south == :nw do
        get_loop_length(sketch, {start_x - 1, start_y}, start, start)
      else
        if north == :ns or north == :se or north == :sw do
          get_loop_length(sketch, {start_x + 1, start_y}, start, start)
        else
          if west == :ew or west == :nw or west == :sw do
            get_loop_length(sketch, {start_x, start_y - 1}, start, start)
          end
        end
      end

    overall_track_len / 2
  end

  def task2 do
    0
  end

  @pipemap %{
    ?| => :ns,
    ?- => :ew,
    ?L => :ne,
    ?J => :nw,
    ?7 => :sw,
    ?F => :se,
    ?. => :gnd,
    ?S => :start
  }

  defp parse_sketch() do
    File.read!("data/day10.txt")
    |> String.split("\n")
    |> Enum.reverse()
    |> Enum.map(fn sketch_line ->
      sketch_line
      |> String.to_charlist()
      |> Enum.map(&Map.fetch!(@pipemap, &1))
    end)
  end

  defp get_start_pos(sketch) do
    sketch
    |> Enum.reduce({{0, 0}, 0}, fn sketch_line, {{x, y}, x_idx} ->
      start_col = Enum.find_index(sketch_line, &(&1 == :start))
      if start_col != nil, do: {{x_idx, start_col}, x_idx + 1}, else: {{x, y}, x_idx + 1}
    end)
    |> then(fn {{y, x}, _} -> {x, y} end)
  end

  defp get_pipe_at(sketch, {y, x}) do
    x_max = Enum.count(sketch)
    y_max = Enum.count(Enum.at(sketch, 0))

    if x < 0 or y < 0 or x >= x_max or y >= y_max do
      :gnd
    else
      Enum.at(sketch, x) |> Enum.at(y)
    end
  end

  defp get_next_pos(sketch, {x, y}, last_pos) do
    case(get_pipe_at(sketch, {x, y})) do
      :ns -> [{x, y + 1}, {x, y - 1}] -- [last_pos]
      :ew -> [{x + 1, y}, {x - 1, y}] -- [last_pos]
      :ne -> [{x + 1, y}, {x, y + 1}] -- [last_pos]
      :nw -> [{x - 1, y}, {x, y + 1}] -- [last_pos]
      :sw -> [{x - 1, y}, {x, y - 1}] -- [last_pos]
      :se -> [{x + 1, y}, {x, y - 1}] -- [last_pos]
      :gnd -> raise RuntimeError
      :start -> [{x, y}]
    end
    |> List.first()
  end

  defp get_loop_length(sketch, current_pos, last_pos, start_pos, acc \\ 0) do
    if current_pos != start_pos do
      next_pos = get_next_pos(sketch, current_pos, last_pos)
      get_loop_length(sketch, next_pos, current_pos, start_pos, acc + 1)
    else
      acc + 1
    end
  end
end
