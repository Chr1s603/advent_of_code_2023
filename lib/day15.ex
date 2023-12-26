defmodule AdventOfCode2023.Day15 do
  @box_cnt 256

  def task1 do
    load_cmds()
    |> Enum.map(&get_hash/1)
    |> Enum.sum()
  end

  def task2 do
    initial_boxes_map =
      List.duplicate([], @box_cnt) |> Enum.with_index() |> Map.new(fn {l, i} -> {i, l} end)

    load_cmds()
    |> Enum.reduce(initial_boxes_map, &parse_cmd/2)
    |> Enum.map(&calc_focus_power/1)
    |> Enum.sum()
  end

  defp load_cmds do
    File.read!("data/day15.txt")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
  end

  defp get_hash(string), do: string |> String.to_charlist() |> hash_internal(0)

  defp hash_internal([char | rest], cv),
    do: hash_internal(rest, Kernel.rem((cv + char) * 17, @box_cnt))

  defp hash_internal(_, cv), do: cv

  defp parse_cmd(cmd, box_map),
    do:
      if(String.contains?(cmd, "="),
        do: parse_add(cmd, box_map),
        else: parse_remove(cmd, box_map)
      )

  defp parse_add(cmd, boxes_map) do
    [label, focal_length] = String.split(cmd, "=")
    box = get_hash(label)
    add_lens_to_box(boxes_map, box, label, String.to_integer(focal_length))
  end

  defp parse_remove(cmd, boxes_map) do
    [label, _] = String.split(cmd, "-")
    box = get_hash(label)
    remove_lens_from_box(boxes_map, box, label)
  end

  defp add_lens_to_box(boxes_map, box, label, fl) do
    new_content =
      boxes_map
      |> Map.fetch!(box)
      |> then(fn prev_content ->
        pos = Enum.find_index(prev_content, fn {lb, _fl} -> lb == label end)

        if pos != nil,
          do: List.replace_at(prev_content, pos, {label, fl}),
          else: prev_content ++ [{label, fl}]
      end)

    Map.put(boxes_map, box, new_content)
  end

  defp remove_lens_from_box(boxes_map, box, label) do
    box_content = boxes_map |> Map.fetch!(box)
    Map.put(boxes_map, box, Enum.reject(box_content, fn {lb, _fl} -> lb == label end))
  end

  defp calc_focus_power({box, lens_list}) do
    lens_list
    |> Enum.with_index()
    |> Enum.map(fn {{_label, fl}, idx} -> (1 + box) * (idx + 1) * fl end)
    |> Enum.sum()
  end
end
