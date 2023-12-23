defmodule AdventOfCode2023.Day14 do
  def task1 do
    load_map()
    |> IO.inspect()
    |> Enum.map(fn line ->
      line |> Enum.reduce({List.to_string(line), 0}, fn char, {acc, idx} ->
        next_free_space = get_next_point(String.slice(acc, idx, String.length(acc)), 0)
        |> IO.inspect()
        updated_line = acc
        if next_free_space >= 0 do



          updated_line = String.slice(acc, 0, idx)
        end

        {acc, idx + 1}
      end)
      line |> IO.inspect()
    end)

    0
  end

  def task2, do: 0

  # North (intial row 0) will be last column
  defp load_map do
    File.read!("data/day14.txt")
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
    |> Enum.reverse()
    |> transpose()
  end

  defp transpose(map) do
    rows = map |> Enum.count()
    cols = map |> Enum.at(0) |> Enum.count()

    0..(cols - 1)
    |> Enum.map(fn r ->
      Enum.map(0..(rows - 1), &(map |> Enum.at(&1) |> Enum.at(r)))
    end)
  end

  defp get_next_point("O" <> rest, idx), do: get_next_point(rest, idx + 1)
  defp get_next_point("." <> _rest, idx), do: idx
  defp get_next_point(_rest, _idx), do: -1

  defp str_swap(a, b) do
    regex = ~r/(.)(.*?)(.)/
    String.replace(string, regex, fn _, before, after -> "#{String.at(before, a)}#{String.replace_before(after, ".", 1)}" end)
  end
end
