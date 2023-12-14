defmodule AdventOfCode2023.Day8 do
  def task1 do
    [instructions, map] = load_instruction_and_map()
    follow_instructions_till_zzz({instructions, 0}, {map, :AAA, :ZZZ})
  end

  def task2 do
    0
  end

  defp load_instruction_and_map do
    [instructions, network] =
      File.read!("data/day8.txt")
      |> String.split(~r/\n{2,}/)

    network =
      network
      |> String.replace([",", "(", ")"], "")
      |> String.split("\n")
      |> Enum.map(&String.split(&1, " = "))
      |> Enum.map(fn [pos, lr] ->
        [l, r] = String.split(lr, " ")
        [String.to_atom(pos), [String.to_atom(l), String.to_atom(r)]]
      end)
      |> Map.new(fn [pos, lr] -> {pos, lr} end)

    [String.to_charlist(instructions), network]
  end

  defp follow_instructions_till_zzz({_, idx}, {_, pos, goal}) when pos == goal, do: idx

  defp follow_instructions_till_zzz({instructions, idx}, {map, pos, goal}) do
    i = Enum.at(instructions, Integer.mod(idx, Enum.count(instructions)))
    [l, r] = Map.fetch!(map, pos)
    next_pos = if i == ?L, do: l, else: r

    follow_instructions_till_zzz({instructions, idx + 1}, {map, next_pos, goal})
  end
end
