defmodule AdventOfCode2023Test do
  use ExUnit.Case
  doctest AdventOfCode2023

  @moduletag timeout: :infinity

  test "day_1" do
    assert AdventOfCode2023.Day1.task1() == 57346
    assert AdventOfCode2023.Day1.task2() == 57345
  end

  test "day_2" do
    assert AdventOfCode2023.Day2.task1() == 2776
    assert AdventOfCode2023.Day2.task2() == 68638
  end

  test "day_3" do
    assert AdventOfCode2023.Day3.task1() == 528799
    assert AdventOfCode2023.Day3.task2() == 84907174
  end

  test "day_4" do
    assert AdventOfCode2023.Day4.task1() == 20855
    assert AdventOfCode2023.Day4.task2() == 5489600
  end

  test "day_5" do
    assert AdventOfCode2023.Day5.task1() == 261668924
    # assert AdventOfCode2023.Day5.task2() == 24261545
  end

  test "day_6" do
    assert AdventOfCode2023.Day6.task1() == 138915
    # assert AdventOfCode2023.Day6.task2() == 27340847
  end

  test "day_7" do
    assert AdventOfCode2023.Day7.task1() == 248179786
    assert AdventOfCode2023.Day7.task2() == 247885995
  end

  test "day_8" do
    assert AdventOfCode2023.Day8.task1() == 18827
    assert AdventOfCode2023.Day8.task2() == 20220305520997
  end

  test "day_9" do
    assert AdventOfCode2023.Day9.task1() == 0
    assert AdventOfCode2023.Day9.task2() == 0
  end
end
