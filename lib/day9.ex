defmodule AdventOfCode2023.Day9 do
  def task1 do
    load_difference_lists()
    |> Enum.map(fn lists ->
      acc = Enum.at(lists, -1) ++ [0]
      extrapolate({Enum.drop(lists, -1), [acc]}, false)
    end)
    |> Enum.map(&List.last/1)
    |> Enum.sum()
  end

  def task2 do
    load_difference_lists()
    |> Enum.map(fn lists ->
      # NOTE: acc is all zero
      acc = Enum.at(lists, -1) ++ [0]
      extrapolate({Enum.drop(lists, -1), [acc]}, true)
    end)
    |> Enum.map(&List.first/1)
    |> Enum.sum()
  end

  defp load_difference_lists() do
    File.stream!("data/day9.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn s -> String.split(s, " ") |> Enum.map(&String.to_integer/1) end)
    |> Enum.map(&calculate_differences([&1]))
  end

  defp calculate_differences(lists) do
    new_list =
      List.last(lists)
      |> Enum.reduce_while({[], nil}, fn current, {result, previous} ->
        case previous do
          nil ->
            {:cont, {result, current}}

          _ ->
            difference = current - previous
            {:cont, {result ++ [difference], current}}
        end
      end)
      |> elem(0)

    if Enum.any?(new_list, &(&1 != 0)) do
      calculate_differences(lists ++ [new_list])
    else
      lists ++ [new_list]
    end
  end

  defp extrapolate({old_lists, acc}, backwards) do
    new_line = Enum.at(old_lists, -1)
    difference = Enum.at(Enum.at(acc, 0), if(backwards, do: 0, else: -1))

    new_line =
      if backwards do
        [Enum.at(new_line, 0) - difference] ++ new_line
      else
        new_line ++ [Enum.at(new_line, -1) + difference]
      end

    if Enum.count(old_lists) - 1 > 0 do
      extrapolate({Enum.drop(old_lists, -1), [new_line | acc]}, backwards)
    else
      new_line
    end
  end
end
