defmodule AdventOfCode2023.Day7 do
  def task1 do
    get_total_wins(false)
  end

  def task2 do
    get_total_wins(true)
  end

  defp get_total_wins(upgrade_jokers) do
    File.read!("data/day7.txt")
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.sort(&is_smaller(&1, &2, upgrade_jokers))
    |> Enum.reduce({0, 1}, fn [_, bid], {sum, rank} ->
      {sum + String.to_integer(bid) * rank, rank + 1}
    end)
    |> then(fn {sum, _} -> sum end)
  end

  def add_j_to_max(freqs) do
    case Map.fetch(freqs, ?J) do
      {:ok, j_value} ->
        {max_key, max_key_value} =
          Map.to_list(freqs)
          |> Enum.reduce({?X, 0}, fn {key, value}, {mk, mv} ->
            if value > mv and key != ?J, do: {key, value}, else: {mk, mv}
          end)

        new_freqs = Map.put(freqs, max_key, j_value + max_key_value)
        if Enum.count(freqs) == 1, do: freqs, else: Map.delete(new_freqs, ?J)

      :error ->
        freqs
    end
  end

  @types %{
    :five_of_a_kind => 6,
    :four_of_a_kind => 5,
    :full_house => 4,
    :three_of_a_kind => 3,
    :two_pair => 2,
    :one_pair => 1,
    :high_card => 0
  }

  defp is_smaller([hand_a, _], [hand_b, _], upgrade_jokers) do
    type_a = hand_a |> get_type_value(upgrade_jokers)
    type_b = hand_b |> get_type_value(upgrade_jokers)

    cond do
      type_a < type_b -> true
      type_a > type_b -> false
      true -> check_second_rule(hand_a, hand_b, upgrade_jokers)
    end
  end

  defp get_type_value(string, upgrade_jokers) do
    freqs =
      String.to_charlist(string)
      |> Enum.frequencies()
      |> then(&if upgrade_jokers, do: add_j_to_max(&1), else: &1)

    case {Enum.count(freqs)} do
      {1} -> :five_of_a_kind
      {2} -> four_of_a_kind_or_full_house(freqs)
      {3} -> three_of_a_kind_or_two_pair(freqs)
      {4} -> :one_pair
      {5} -> :high_card
    end
    |> then(&Map.fetch!(@types, &1))
  end

  defp four_of_a_kind_or_full_house(map),
    do: if(Enum.member?(Map.values(map), 3), do: :full_house, else: :four_of_a_kind)

  defp three_of_a_kind_or_two_pair(map),
    do: if(Enum.member?(Map.values(map), 3), do: :three_of_a_kind, else: :two_pair)

  @card_label_values %{
    ?A => 12,
    ?K => 11,
    ?Q => 10,
    ?J => 9,
    ?T => 8,
    ?9 => 7,
    ?8 => 6,
    ?7 => 5,
    ?6 => 4,
    ?5 => 3,
    ?4 => 2,
    ?3 => 1,
    ?2 => 0
  }

  defp check_second_rule(
         <<char_a::utf8, rest_a::binary>>,
         <<char_b::utf8, rest_b::binary>>,
         joker_weakest
       ) do
    # For task 2, lower value of J below 2 (which is 0)
    card_label_values =
      @card_label_values
      |> then(fn map -> if joker_weakest, do: Map.put(map, ?J, -1), else: map end)

    val_a = Map.fetch!(card_label_values, char_a)
    val_b = Map.fetch!(card_label_values, char_b)

    cond do
      val_a < val_b -> true
      val_a > val_b -> false
      true -> check_second_rule(rest_a, rest_b, joker_weakest)
    end
  end
end
