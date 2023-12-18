defmodule AdventOfCode2023.Day13 do
  def task1 do
    parse_patterns()
    |> Enum.map(&process_pattern/1)
    |> Enum.sum()
  end

  def task2 do
    0
  end

  defp parse_patterns() do
    File.read!("data/day13.txt")
    |> String.split(~r/\n{2,}/)
    |> Enum.map(&String.split(&1, "\n"))
  end

  defp get_refl_row(p, rows, row_id) do
    to_fetch = min(row_id + 1, rows - row_id - 1)

    #IO.puts("RowID #{row_id} tofetch #{to_fetch}")

    upper = p |> Enum.slice((row_id + 1 - to_fetch)..row_id)
    lower = p |> Enum.slice((row_id + 1)..(row_id + to_fetch)) |> Enum.reverse()

    #IO.puts("UPPER")
    #IO.inspect(upper)
    #IO.puts("LOWER")
    #IO.inspect(lower)

    upper
    |> Enum.zip(lower)
    |> Enum.filter(fn {upper, lower} -> upper != lower end)
    #|> IO.inspect()
    |> then(
      &if(Enum.count(&1) == 0) do
        row_id + 1
      else
        if row_id >= rows - 2 do
          -1
        else
          get_refl_row(p, rows, row_id + 1)
        end
      end
    )
  end

  defp process_pattern(p_str) do
    p = p_str |> Enum.map(&String.to_charlist/1)
    rows = p |> Enum.count()
    cols = p |> Enum.at(0) |> Enum.count()

    get_refl_row(p, rows, 0)
    |> IO.inspect()
    |> then(fn vidx ->
      if vidx >= 0 do
        IO.puts("ROW MIRRORING @#{vidx}")
        vidx * 100
      else
        x = p |> transpose_pattern(rows, cols) |> get_refl_row(cols, 0)
        x
      end
    end)
  end

  defp transpose_pattern(p, rows, cols) do
    0..(cols - 1)
    |> Enum.map(fn r ->
      Enum.map(0..(rows - 1), &(Enum.at(p, &1) |> Enum.at(r)))
    end)
  end
end
