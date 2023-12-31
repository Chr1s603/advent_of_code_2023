defmodule AdventOfCode2023.Day19 do
  def task1 do
    {workflows, parts} = load_input()

    parts
    |> Enum.map(&walk(workflows, :in, &1))
    |> Enum.zip(parts)
    |> Enum.map(&score/1)
    |> Enum.sum()
  end

  def task2 do
    {workflows, _parts} = load_input()

    combs(workflows, Map.fetch!(workflows, :in), %{
      :x => {1, 4001},
      :m => {1, 4001},
      :a => {1, 4001},
      :s => {1, 4001}
    })
  end

  defp combs(map, [{field, op, thresh, res} | tail], threshs) do
    # New constraints for {f,o,t,r} and the reversed ones for res
    {new_thresh, rev_thresh} = split_treshs(threshs, field, op, thresh)
    combs(map, res, new_thresh) + combs(map, tail, rev_thresh)
  end

  defp combs(_map, :A, threshs) do
    threshs
    |> Enum.map(fn {_, {min, max}} -> max - min end)
    |> Enum.map(&max(&1, 0))
    |> Enum.reduce(1, &(&1 * &2))
  end

  defp combs(_map, :R, _threshs), do: 0
  defp combs(map, [key], threshs), do: combs(map, key, threshs)
  defp combs(map, key, threshs), do: combs(map, Map.fetch!(map, key), threshs)

  defp split_treshs(threshs, field, ">", thresh) do
    {Map.update!(threshs, field, fn {min, max} ->
       {max(min, thresh + 1), max}
     end),
     Map.update!(threshs, field, fn {min, max} ->
       {min, min(max, thresh + 1)}
     end)}
  end

  defp split_treshs(threshs, field, "<", thresh) do
    {Map.update!(threshs, field, fn {min, max} ->
       {min, min(max, thresh)}
     end),
     Map.update!(threshs, field, fn {min, max} ->
       {max(min, thresh), max}
     end)}
  end

  defp score({:R, _}), do: 0
  defp score({:A, %{:x => x, :m => m, :a => a, :s => s}}), do: x + m + a + s

  defp walk(map, wf_name, part) do
    Map.fetch!(map, wf_name)
    |> Enum.find(fn
      {field, ">", thresh, _} ->
        part
        |> Map.fetch!(field)
        |> Kernel.>(thresh)

      {field, "<", thresh, _} ->
        part
        |> Map.fetch!(field)
        |> Kernel.<(thresh)

      _ ->
        true
    end)
    |> then(fn
      {_, _, _, res} -> res
      solo -> solo
    end)
    |> case do
      :A -> :A
      :R -> :R
      new_wf_name -> walk(map, new_wf_name, part)
    end
  end

  defp load_input do
    [workflows, parts] = File.read!("data/day19.txt") |> String.split("\n\n")
    {parse_workflows(workflows), parse_parts(parts)}
  end

  defp parse_workflows(str) do
    String.split(str, "\n")
    |> Enum.map(&(String.replace(&1, "}", "") |> String.split("{")))
    |> Enum.reduce(Map.new(), fn [label, rules], acc ->
      Map.merge(acc, %{String.to_atom(label) => parse_rules(rules)})
    end)
  end

  defp parse_rules(rules) do
    rules
    |> String.split(",")
    |> Enum.map(&String.split(&1, ":"))
    |> Enum.map(fn
      [solo] ->
        String.to_atom(solo)

      [<<category::bytes-size(1), op::bytes-size(1), thresh::binary>>, res] ->
        {String.to_atom(category), op, String.to_integer(thresh), String.to_atom(res)}
    end)
  end

  defp parse_parts(str) do
    String.split(str, "\n")
    |> Enum.map(&String.replace(&1, ["{", "}"], ""))
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn [x, m, a, s] ->
      %{:x => get_val(x), :m => get_val(m), :a => get_val(a), :s => get_val(s)}
    end)
  end

  defp get_val(str), do: String.split(str, "=") |> then(fn [_, n] -> String.to_integer(n) end)
end
