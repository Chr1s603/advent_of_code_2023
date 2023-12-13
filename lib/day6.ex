defmodule AdventOfCode2023.Day6 do
  def task1 do
    load_time_dist_pairs()
    |> Enum.map(fn {time, record} ->
      1..(time - 1)
      |> Enum.map(&calc_distance(&1, time))
      |> Enum.reject(&(&1 <= record))
      |> Enum.count()
    end)
    |> Enum.reduce(1, &(&1 * &2))
  end

  def task2 do
    load_time_dist_pairs()
    |> Enum.map(fn {time, record} -> {Integer.to_string(time), Integer.to_string(record)} end)
    |> Enum.reduce({"", ""}, fn {time, record}, {new_time, new_record} ->
      {new_time <> time, new_record <> record}
    end)
    |> then(fn {t, r} -> {String.to_integer(t), String.to_integer(r)} end)
    |> then(fn {t, r} ->
      1..(t - 1)
      |> Enum.map(&calc_distance(&1, t))
      |> Enum.reject(&(&1 <= r))
      |> Enum.count()
    end)
    |> IO.inspect()
  end

  defp parse_values(string, token) do
    String.replace(string, token, "")
    |> String.split(" ")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.to_integer/1)
  end

  defp load_time_dist_pairs() do
    [time_str, dist_str] =
      File.read!("data/day6.txt")
      |> String.split("\n")

    Enum.zip(parse_values(time_str, "Time:"), parse_values(dist_str, "Distance:"))
  end

  defp calc_distance(hold_time, overall_time) when hold_time in [0, overall_time], do: 0
  defp calc_distance(hold_time, overall_time), do: (overall_time - hold_time) * hold_time
end
