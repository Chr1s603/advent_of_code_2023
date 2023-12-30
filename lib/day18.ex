defmodule AdventOfCode2023.Day18 do
  def task1 do
    dp =
      load_dig_plan()
      |> exec_dig_plan()
      |> count_marked_cells_and_enclosed_cells()
      |> IO.inspect()

    0
  end

  def task2 do
    0
  end

  defp load_dig_plan do
    File.stream!("data/day18.txt")
    |> Enum.map(&String.replace(&1, ["\n", "(", ")", "#"], ""))
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [dir, num_s, rgb] -> {String.to_atom(dir), String.to_integer(num_s), rgb} end)
  end

  defp exec_dig_plan(plan) do
    plan
    |> Enum.reduce({{0, 0}, %{{0, 0} => ?#}}, fn {dir, cnt, _rgb}, {{x, y}, map} ->
      case dir do
        :U ->
          (y + 1)..(y + cnt)
          |> Enum.reduce(map, &Map.merge(&2, %{{x, &1} => ?#}))
          |> then(fn m -> {{x, y + cnt}, m} end)

        :D ->
          (y - 1)..(y - cnt)
          |> Enum.reduce(map, &Map.merge(&2, %{{x, &1} => ?#}))
          |> then(fn m -> {{x, y - cnt}, m} end)

        :R ->
          (x + 1)..(x + cnt)
          |> Enum.reduce(map, &Map.merge(&2, %{{&1, y} => ?#}))
          |> then(fn m -> {{x + cnt, y}, m} end)

        :L ->
          (x - 1)..(x - cnt)
          |> Enum.reduce(map, &Map.merge(&2, %{{&1, y} => ?#}))
          |> then(fn m -> {{x - cnt, y}, m} end)
      end
    end)
    |> then(fn {_pos, map} -> map end)
  end

  defp print_map(map) do
    keys = map |> Map.keys()
    x_min = keys |> Enum.map(fn {x, _y} -> x end) |> Enum.min()
    x_max = keys |> Enum.map(fn {x, _y} -> x end) |> Enum.max()
    y_min = keys |> Enum.map(fn {_x, y} -> y end) |> Enum.min()
    y_max = keys |> Enum.map(fn {_x, y} -> y end) |> Enum.max()

    y_max..y_min
    |> Enum.reduce([], fn y, outer_acc ->
      x_min..x_max
      |> Enum.reduce("", fn x, inner_acc ->
        case Map.fetch(map, {x, y}) do
          {:ok, _} -> inner_acc <> "#"
          _ -> inner_acc <> " "
        end
      end)
      |> then(fn newline ->
        outer_acc ++ [String.to_charlist(newline)]
      end)
    end)
    |> Enum.map(&IO.puts/1)
  end

  def count_marked_cells_and_enclosed_cells(map) do
    keys = map |> Map.keys()
    x_min = keys |> Enum.map(fn {x, _y} -> x end) |> Enum.min()
    x_max = keys |> Enum.map(fn {x, _y} -> x end) |> Enum.max()
    y_min = keys |> Enum.map(fn {_x, y} -> y end) |> Enum.min()
    y_max = keys |> Enum.map(fn {_x, y} -> y end) |> Enum.max()

    y_max..y_min
    |> Enum.reduce(0, fn y, outer_acc ->
      x_min..x_max
      |> Enum.reduce([], fn x, inner_acc ->
        case Map.fetch(map, {x, y}) do
          {:ok, _} -> inner_acc ++ [x]
          _ -> inner_acc
        end
      end)
      |> then(fn lighted ->
        lighted |> IO.inspect() |> Enum.chunk_every(2) |> Enum.map(fn [a, b] -> b - a + 1 end) |> Enum.sum()
      end)
      |> then(&(&1 + outer_acc))
    end)
  end
end
