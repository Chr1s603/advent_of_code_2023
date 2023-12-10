defmodule AdventOfCode2023.Day4 do
  def task1 do
    File.stream!("data/day4.txt")
    |> Enum.map(&remove_card_id/1)
    |> Enum.map(fn str -> String.split(str, "|") end)
    |> Enum.map(&count_correct_numbers/1)
    |> Enum.map(&if &1 == 0, do: 0, else: Integer.pow(2, &1 - 1))
    |> Enum.sum()
  end

  def task2 do
    File.stream!("data/day4.txt")
    0
  end

  defp remove_card_id(line), do: String.replace(line, ~r/Card\s+\d+: /, "")

  defp count_correct_numbers([wins, guesses]) do
    win_nums =
      String.trim(wins) |> String.split(" ") |> Enum.reject(fn e -> e == "" end) |> MapSet.new()

    guess_nums =
      String.trim(guesses)
      |> String.split(" ")
      |> Enum.reject(fn e -> e == "" end)
      |> MapSet.new()

    IO.inspect(win_nums)
    IO.inspect(guess_nums)

    MapSet.intersection(win_nums, guess_nums)
    |> Enum.count()
  end
end
