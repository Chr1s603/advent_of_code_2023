defmodule AdventOfCode2023.Day4 do
  def task1 do
    File.read!("data/day4.txt")
    |> String.split("\n")
    |> Enum.map(&remove_card_id/1)
    |> Enum.map(fn str -> String.split(str, "|") end)
    |> Enum.map(&count_correct_numbers/1)
    |> Enum.map(&if &1 == 0, do: 0, else: Integer.pow(2, &1 - 1))
    |> Enum.sum()
  end

  def task2 do
    {_, overall_card_count} =
      File.read!("data/day4.txt")
      |> String.split("\n")
      |> Enum.map(&remove_card_id/1)
      |> Enum.map(fn str -> String.split(str, "|") end)
      |> Enum.reduce({[], 0}, fn card, {to_dup, card_count} ->
        # copies includes the original card, so it is 1 at minimum
        winning_numbers = count_correct_numbers(card)
        copies = if Enum.count(to_dup) > 0, do: Enum.at(to_dup, 0), else: 1

        {increase_first_elements(
           Enum.slice(to_dup, 1, Enum.count(to_dup)),
           winning_numbers,
           copies
         ), card_count + copies}
      end)

    overall_card_count
  end

  def increase_first_elements(list, wins, mult) do
    new_size = max(length(list), wins)

    (list ++ List.duplicate(1, new_size - length(list)))
    |> Enum.take(wins)
    |> Enum.map(&(&1 + mult))
    |> Enum.concat(Enum.drop(list, wins))
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

    MapSet.intersection(win_nums, guess_nums)
    |> Enum.count()
  end
end
