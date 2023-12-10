defmodule AdventOfCode2023.Day3 do
  def task1 do
    File.stream!("data/day3.txt")
    |> Enum.reduce([[], 0], &parse_numbers/2)
    |> Enum.at(1)
  end

  def task2 do
    File.stream!("data/day3.txt")

    0
  end

  def parse_numbers(line, acc) do
    current_symbols = find_symbol_indices(String.trim(line))

    [last_symbols, sum] = acc
    [current_symbols, sum + sum_part_numbers_of_line(line, last_symbols)]
  end

  defp sum_part_numbers_of_line(str, indices) do
    nums_in_line = extract_digit_ranges(str, [], 0)

    0
  end

  def convert(binary) do
    for c <- binary, into: "", do: <<c>>
  end

  def extract_digit_ranges(<<char::utf8, rest::binary>>, ranges, idx) when char not in ?0..?9 do
    extract_digit_ranges(rest, ranges, idx + 1)
  end

  def extract_digit_ranges(<<char::utf8, rest::binary>>, ranges, idx) when char in ?0..?9 do
    complete = <<char::utf8, rest::binary>>
    number_string =
      Regex.run(~r/^(\d+)/, complete)
      |> Enum.at(0)
    num_str_len = String.length(number_string)

    range = [idx - 1, idx + num_str_len + 1]

    extract_digit_ranges(String.slice(complete, num_str_len, String.length(complete)), [range | ranges], idx + num_str_len)
  end

  def extract_digit_ranges(_, ranges, _) do
    ranges
  end

  defp find_symbol_indices(str), do: find_symbol_indices(str, 0, [])

  defp find_symbol_indices("", _, indices), do: Enum.reverse(indices)

  defp find_symbol_indices(<<char::utf8, rest::binary>>, index, indices)
       when char in ?0..?9 or char == ?.,
       do: find_symbol_indices(rest, index + 1, indices)

  defp find_symbol_indices(<<_char::utf8, rest::binary>>, index, indices),
    do: find_symbol_indices(rest, index + 1, [index | indices])
end
