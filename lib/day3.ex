defmodule AdventOfCode2023.Day3 do
  def task1 do
    lines = File.stream!("data/day3.txt") |> Enum.map(&String.trim/1)
    symbol_indices = lines |> Enum.map(&find_symbol_indices/1)

    symbol_chunks =
      ([Enum.slice(symbol_indices, 0..1)] ++ Enum.chunk_every(symbol_indices, 3, 1))
      |> Enum.map(&List.flatten/1)

    Enum.zip(lines, symbol_chunks)
    |> Enum.map(fn {line, chunk} -> sum_part_numbers_of_line(line, chunk) end)
    |> Enum.sum()
  end

  def task2 do
    lines = File.stream!("data/day3.txt") |> Enum.map(&String.trim/1)
    star_indices = lines |> Enum.map(&find_star_indices/1)
    nums_and_rngs = lines |> Enum.map(&get_numbers_and_their_ranges/1)

    nums_and_rngs_chunks =
      ([Enum.slice(nums_and_rngs, 0..1)] ++ Enum.chunk_every(nums_and_rngs, 3, 1))
      |> Enum.map(&List.flatten/1)

    Enum.zip(star_indices, nums_and_rngs_chunks)
    |> Enum.map(fn {star_indices, nums_and_rngs} ->
      get_gear_ratios_of_line(star_indices, nums_and_rngs)
    end)
    |> Enum.sum()
  end

  defp get_numbers_and_their_ranges(str) do
    digit_ranges = extract_digit_ranges(str, [], 0) |> Enum.map(fn [s, e] -> [s, e] end)

    nums_in_line =
      Enum.map(digit_ranges, fn [s, e] ->
        String.slice(str, s, e - s + 1) |> String.to_integer()
      end)

    Enum.zip(digit_ranges, nums_in_line)
  end

  defp sum_part_numbers_of_line(str, indices) do
    get_numbers_and_their_ranges(str)
    |> Enum.map(fn {[s, e], num} ->
      if Enum.any?(indices, fn idx -> idx <= e + 1 and idx >= s - 1 end), do: num, else: 0
    end)
    |> Enum.sum()
  end

  defp is_gear_ratio(star_idx, nums_and_rngs) do
    {matches, _} =
      Enum.reduce(nums_and_rngs, {[], 0}, fn {[start, stop], value}, {matches, count} ->
        if start - 1 <= star_idx && star_idx <= stop + 1 do
          {[value | matches], count + 1}
        else
          {matches, count}
        end
      end)

    if length(matches) == 2 do
      Enum.reduce(matches, 1, fn elem, acc -> elem * acc end)
    else
      0
    end
  end

  defp get_gear_ratios_of_line(star_indices, nums_and_rngs) do
    star_indices
    |> Enum.map(fn idx -> is_gear_ratio(idx, nums_and_rngs) end)
    |> Enum.sum()
  end

  #
  # Extract digit ranges
  #

  def extract_digit_ranges(<<char::utf8, rest::binary>>, ranges, idx) when char not in ?0..?9 do
    extract_digit_ranges(rest, ranges, idx + 1)
  end

  def extract_digit_ranges(<<char::utf8, rest::binary>>, ranges, idx) when char in ?0..?9 do
    complete = <<char::utf8, rest::binary>>
    num_str = Regex.run(~r/\A\d+/, complete) |> Enum.at(0)
    num_str_len = String.length(num_str)
    range = [idx, idx + num_str_len - 1]

    extract_digit_ranges(
      String.slice(complete, num_str_len, String.length(complete)),
      [range | ranges],
      idx + num_str_len
    )
  end

  def extract_digit_ranges(_, ranges, _) do
    Enum.reverse(ranges)
  end

  #
  # Find symbol indices
  #

  defp find_symbol_indices(str), do: find_symbol_indices(str, 0, [])

  defp find_symbol_indices("", _, indices), do: Enum.reverse(indices)

  defp find_symbol_indices(<<char::utf8, rest::binary>>, index, indices)
       when char in ?0..?9 or char == ?.,
       do: find_symbol_indices(rest, index + 1, indices)

  defp find_symbol_indices(<<_char::utf8, rest::binary>>, index, indices),
    do: find_symbol_indices(rest, index + 1, [index | indices])

  #
  # Find star indices
  #

  defp find_star_indices(str), do: find_star_indices(str, 0, [])

  defp find_star_indices("", _, indices), do: Enum.reverse(indices)

  defp find_star_indices(<<char::utf8, rest::binary>>, index, indices)
       when char != ?*,
       do: find_star_indices(rest, index + 1, indices)

  defp find_star_indices(<<_char::utf8, rest::binary>>, index, indices),
    do: find_star_indices(rest, index + 1, [index | indices])
end
