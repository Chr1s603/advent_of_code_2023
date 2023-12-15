defmodule AdventOfCode2023.Day8 do
  import Math

  def task1 do
    [instructions, map, _] = load_instruction_and_map()
    get_period_for_being_in_xxZ({instructions, 0, 0, 0}, {map, :AAA})
  end

  def task2 do
    [instructions, map, all_ending_a] = load_instruction_and_map()

    periods_for_reaching_xxZ =
      Enum.map(all_ending_a, &get_period_for_being_in_xxZ({instructions, 0, 0, 0}, {map, &1}))

    Enum.reduce(
      Enum.slice(periods_for_reaching_xxZ, 1, Enum.count(periods_for_reaching_xxZ)),
      Enum.at(periods_for_reaching_xxZ, 0),
      fn current_period, lcm -> Math.lcm(current_period, lcm) end
    )
  end

  defp load_instruction_and_map do
    [instructions, network] =
      File.read!("data/day8.txt")
      |> String.split(~r/\n{2,}/)

    map_str =
      network
      |> String.replace([",", "(", ")"], "")
      |> String.split("\n")
      |> Enum.map(&String.split(&1, " = "))
      |> Enum.map(fn [pos, lr] -> [pos, String.split(lr, " ")] end)

    all_ending_a =
      map_str
      |> Enum.reject(fn [pos, _] -> not String.ends_with?(pos, "A") end)
      |> Enum.map(fn [pos, _] -> String.to_atom(pos) end)

    map =
      map_str
      |> Enum.map(fn [pos, [l, r]] ->
        [String.to_atom(pos), [String.to_atom(l), String.to_atom(r)]]
      end)
      |> Map.new(fn [pos, lr] -> {pos, lr} end)

    [String.to_charlist(instructions), map, all_ending_a]
  end

  defp get_period_for_being_in_xxZ(
         {instructions, idx, last_idx_when_reaching_pos_with_z, reached_cnt},
         {map, pos}
       ) do
    i = Enum.at(instructions, Integer.mod(idx, Enum.count(instructions)))
    [l, r] = Map.fetch!(map, pos)
    next_pos = if i == ?L, do: l, else: r
    at_pos_with_final_z = Atom.to_string(next_pos) |> String.ends_with?("Z")

    cond do
      at_pos_with_final_z ->
        reached_cnt = reached_cnt + if at_pos_with_final_z, do: +1, else: 0

        cond do
          reached_cnt >= 2 ->
            idx - last_idx_when_reaching_pos_with_z

          true ->
            get_period_for_being_in_xxZ(
              {instructions, idx + 1, idx, reached_cnt},
              {map, next_pos}
            )
        end

      not at_pos_with_final_z ->
        get_period_for_being_in_xxZ(
          {instructions, idx + 1, last_idx_when_reaching_pos_with_z, reached_cnt},
          {map, next_pos}
        )
    end
  end
end
