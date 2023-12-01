defmodule AdventOfCode2023.Day1 do
  def task1 do
    File.stream!("data/day1.txt")
    |> Enum.reduce(0, fn line, acc -> acc + process_line(line) end)
  end

  def task2 do
    File.stream!("data/day1.txt")
    |> Enum.map(&replace_spelt_numbers/1)
    |> Enum.reduce(0, fn line, acc -> acc + process_line(line) end)
  end

  defp process_line(line) do
    only_digit_line = String.replace(line, ~r/\D/, "")

    first_digit = String.at(only_digit_line, 0) |> String.to_integer()
    last_digit = String.at(only_digit_line, -1) |> String.to_integer()

    first_digit * 10 + last_digit
  end

  def replace_spelt_numbers("one" <> rest), do: "1" <> replace_spelt_numbers("e" <> rest)
  def replace_spelt_numbers("two" <> rest), do: "2" <> replace_spelt_numbers("o" <> rest)
  def replace_spelt_numbers("three" <> rest), do: "3" <> replace_spelt_numbers("e" <> rest)
  def replace_spelt_numbers("four" <> rest), do: "4" <> replace_spelt_numbers(rest)
  def replace_spelt_numbers("five" <> rest), do: "5" <> replace_spelt_numbers("e" <> rest)
  def replace_spelt_numbers("six" <> rest), do: "6" <> replace_spelt_numbers(rest)
  def replace_spelt_numbers("seven" <> rest), do: "7" <> replace_spelt_numbers("n" <> rest)
  def replace_spelt_numbers("eight" <> rest), do: "8" <> replace_spelt_numbers("t" <> rest)
  def replace_spelt_numbers("nine" <> rest), do: "9" <> replace_spelt_numbers("e" <> rest)
  def replace_spelt_numbers(<<char, rest::binary>>), do: <<char>> <> replace_spelt_numbers(rest)
  def replace_spelt_numbers(""), do: ""
end
