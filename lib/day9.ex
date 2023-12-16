defmodule AdventOfCode2023.Day9 do
  def task1 do
    File.stream!("data/day9.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn str_list -> Enum.map(str_list, &String.to_integer/1) end)
    |> Enum.map(&calculate_differences([&1]))
    |> Enum.map(fn lists ->
      acc = Enum.at(lists, -1) ++ [0]
      extrapolate({Enum.drop(lists, -1), [acc]})
    end)
    |> Enum.map(&List.last/1)
    |> Enum.sum()
  end

  def task2 do
    0
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

  defp extrapolate({old_lists, acc}) do
    new_line = Enum.at(old_lists, -1)
    difference = Enum.at(Enum.at(acc, 0), -1)
    new_line = new_line ++ [Enum.at(new_line, -1) + difference]

    if Enum.count(old_lists) - 1 > 0 do
      extrapolate({Enum.drop(old_lists, -1), [new_line | acc]})
    else
      new_line
    end
  end
end
