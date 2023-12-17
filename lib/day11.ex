defmodule AdventOfCode2023.Day11 do
  def task1 do
    map = parse_map()
    height = map |> Enum.count()
    width = map |> Enum.at(0) |> Enum.count()

    map
    |> expand(width, height)
    |> get_all_galaxy_indices()
    |> generate_pairs()
    |> Enum.map(fn [pos1, pos2] -> manhattan_distance(pos1, pos2) end)
    |> Enum.sum()
  end

  def task2 do
    0
  end

  defp parse_map() do
    File.read!("data/day11.txt")
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
  end

  defp manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  defp generate_pairs([]), do: []
  defp generate_pairs([_]), do: []

  defp generate_pairs(positions) do
    for pos1 <- positions, pos2 <- positions, pos1 < pos2, do: [pos1, pos2]
  end

  def get_all_galaxy_indices(map) do
    map
    |> Enum.map(&get_galaxy_indices_line/1)
    |> Enum.reduce({[], 0}, fn gs_per_line, {galaxies, idx} ->
      {galaxies ++ Enum.zip(gs_per_line, List.duplicate(idx, Enum.count(gs_per_line))), idx + 1}
    end)
    |> then(fn {positions, _} -> positions end)
  end

  def get_galaxy_indices_line(line) do
    line
    |> Enum.with_index(fn element, index -> {element, index} end)
    |> Enum.filter(fn {char, _index} -> char == ?# end)
    |> Enum.map(&elem(&1, 1))
  end

  defp get_all_galaxy_cols(g_idx_list, columns) do
    occupied_cols =
      g_idx_list
      |> List.flatten()
      |> Enum.uniq()

    0..(columns - 1)
    |> Enum.reject(&Enum.member?(occupied_cols, &1))
  end

  defp get_all_galaxy_rows(g_idx_list) do
    g_idx_list
    |> Enum.with_index(fn element, index -> {element, index} end)
    |> Enum.filter(fn {element, _} -> Enum.count(element) == 0 end)
    |> Enum.map(fn {_, index} -> index end)
  end

  defp expand(map, w, h) do
    idx_per_line = map |> Enum.map(&get_galaxy_indices_line/1)
    g_col_list_sorted = idx_per_line |> get_all_galaxy_cols(h)
    g_row_list_sorted = idx_per_line |> get_all_galaxy_rows()

    row_expanded =
      g_row_list_sorted
      |> Enum.reduce(map, fn row, acc -> List.insert_at(acc, row + 1, List.duplicate(?., w)) end)

    g_col_list_sorted
    |> Enum.reduce({row_expanded, 0}, fn col, {acc, idx} ->
      {Enum.map(acc, fn line -> List.insert_at(line, col + idx, ?.) end), idx + 1}
    end)
    |> then(fn {exp_map, _} -> exp_map end)
  end
end
