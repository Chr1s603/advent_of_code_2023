defmodule AdventOfCode2023.Day2 do
  def task1 do
    File.stream!("data/day2.txt")
    |> Enum.map(&parse_game_string/1)
    |> Enum.reject(fn result -> is_invalid(Map.fetch!(result, :colors)) end)
    |> Enum.map(fn result -> Map.fetch!(result, :id) end)
    |> Enum.sum()
  end

  def task2 do
    File.stream!("data/day2.txt")
    |> Enum.map(&parse_game_string/1)
    |> Enum.map(fn result -> calc_power(Map.fetch!(result, :colors)) end)
    |> Enum.sum()
  end

  def parse_game_string(game_string) do
    splitted_list =
      String.replace(game_string, [",", ";", ":"], "")
      |> String.trim()
      |> String.split(" ")

    game_id = String.to_integer(Enum.at(splitted_list, 1))

    colors =
      Enum.slice(splitted_list, 2, Enum.count(splitted_list) - 2)
      |> Enum.chunk_every(2)
      |> Enum.reduce(%{}, fn [count, color], acc ->
        Map.merge(acc, %{String.to_atom(color) => String.to_integer(count)}, fn _k, v1, v2 ->
          Kernel.max(v1, v2)
        end)
      end)

    %{
      :id => game_id,
      :colors => colors
    }
  end

  defp is_invalid(map) do
    red_count = Map.fetch!(map, :red)
    green_count = Map.fetch!(map, :green)
    blue_count = Map.fetch!(map, :blue)

    red_count > 12 or green_count > 13 or blue_count > 14
  end

  defp calc_power(map) do
    red_count = Map.fetch!(map, :red)
    green_count = Map.fetch!(map, :green)
    blue_count = Map.fetch!(map, :blue)

    red_count * green_count * blue_count
  end
end
