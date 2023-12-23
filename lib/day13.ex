defmodule AdventOfCode2023.Day13 do
  def task1, do: parse_patterns() |> Enum.map(&process_pattern(&1, false)) |> Enum.sum()
  def task2, do: parse_patterns() |> Enum.map(&process_pattern(&1, true)) |> Enum.sum()

  defp parse_patterns do
    File.read!("data/day13.txt")
    |> String.split(~r/\n{2,}/)
    |> Enum.map(&String.split(&1, "\n"))
  end

  defp get_refl_row(p, rows, row_id, correct_smudge) do
    to_fetch = min(row_id + 1, rows - row_id - 1)
    upper = p |> Enum.slice((row_id + 1 - to_fetch)..row_id)
    lower = p |> Enum.slice((row_id + 1)..(row_id + to_fetch)) |> Enum.reverse()

    upper
    |> Enum.zip(lower)
    |> Enum.map(&count_diff_elems/1)
    |> Enum.sum()
    |> then(fn diffs ->
      if(if correct_smudge, do: diffs == 1, else: diffs == 0) do
        row_id + 1
      else
        if row_id >= rows - 2,
          do: -1,
          else: get_refl_row(p, rows, row_id + 1, correct_smudge)
      end
    end)
  end

  defp count_diff_elems({a, b}), do: Enum.zip(a, b) |> Enum.count(fn {x, y} -> x != y end)

  defp process_pattern(p_str, correct_smudge) do
    p = p_str |> Enum.map(&String.to_charlist/1)
    rows = p |> Enum.count()
    cols = p |> Enum.at(0) |> Enum.count()

    get_refl_row(p, rows, 0, correct_smudge)
    |> then(fn vidx ->
      if vidx >= 0,
        do: vidx * 100,
        else: p |> transpose_pattern(rows, cols) |> get_refl_row(cols, 0, correct_smudge)
    end)
  end

  defp transpose_pattern(p, rows, cols) do
    0..(cols - 1)
    |> Enum.map(fn r ->
      Enum.map(0..(rows - 1), &(Enum.at(p, &1) |> Enum.at(r)))
    end)
  end
end
