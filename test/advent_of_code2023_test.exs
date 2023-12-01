defmodule AdventOfCode2023Test do
  use ExUnit.Case
  doctest AdventOfCode2023

  test "day_1" do
    assert AdventOfCode2023.Day1.task1() == 57346
    assert AdventOfCode2023.Day1.task2() == 57345
  end
end
