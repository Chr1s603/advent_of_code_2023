defmodule AdventOfCode2023.General do
  def transpose_2d_list(p, rows, cols) do
    0..(cols - 1)
    |> Enum.map(fn r ->
      Enum.map(0..(rows - 1), &(Enum.at(p, &1) |> Enum.at(r)))
    end)
  end

  def print_2d_map(map, cols, rows) do
    0..(rows - 1)
    |> Enum.map(fn y ->
      0..(cols - 1)
      |> Enum.map(fn x ->
        IO.write("#{[Map.fetch!(map, {x, y})]}")
      end)
      IO.puts("")
    end)
  end

  def add_if_not_present(list, value) do
    if Enum.member?(list, value) do
      list
    else
      [value | list]
    end
  end
end
