defmodule AdventOfCode2023Test do
  use ExUnit.Case
  doctest AdventOfCode2023

  test "day_1" do
    assert AdventOfCode2023.Day1.task1() == 57346
    assert AdventOfCode2023.Day1.task2() == 57345
  end

  test "day_2" do
    assert AdventOfCode2023.Day2.task1() == 2776
    assert AdventOfCode2023.Day2.task2() == 68638
  end

  test "day_3" do
    assert AdventOfCode2023.Day4.task1() == 0
    assert AdventOfCode2023.Day4.task2() == 0
  end
end
