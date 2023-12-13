defmodule AdventOfCode2023.Day5 do
  def task1 do
    [seeds, mappings] = load_seeds_and_mappings()

    Enum.map(seeds, fn seed ->
      get_destination(seed, Map.fetch!(mappings, :seed_to_soil))
      |> get_destination(Map.fetch!(mappings, :soil_to_fertilizer))
      |> get_destination(Map.fetch!(mappings, :fertilizer_to_water))
      |> get_destination(Map.fetch!(mappings, :water_to_light))
      |> get_destination(Map.fetch!(mappings, :light_to_temperature))
      |> get_destination(Map.fetch!(mappings, :temperature_to_humidity))
      |> get_destination(Map.fetch!(mappings, :humidity_to_location))
    end)
    |> Enum.min()
  end

  def task2 do
    [seed_ranges, mappings] = load_seeds_and_mappings()

    Enum.chunk_every(seed_ranges, 2)
    |> Enum.map(fn [start, range] ->
      Enum.to_list(start..(start + range))
      |> Enum.map(fn seed ->
        get_destination(seed, Map.fetch!(mappings, :seed_to_soil))
        |> get_destination(Map.fetch!(mappings, :soil_to_fertilizer))
        |> get_destination(Map.fetch!(mappings, :fertilizer_to_water))
        |> get_destination(Map.fetch!(mappings, :water_to_light))
        |> get_destination(Map.fetch!(mappings, :light_to_temperature))
        |> get_destination(Map.fetch!(mappings, :temperature_to_humidity))
        |> get_destination(Map.fetch!(mappings, :humidity_to_location))
      end)
      |> Enum.min()
    end)
    |> Enum.min()
  end

  defp load_seeds_and_mappings() do
    File.read!("data/day5.txt")
    |> String.split(~r/\n{2,}/)
    |> Enum.map(&parse_maps_or_seeds/1)
    |> Enum.reduce(Map.new(), &Map.merge/2)
    |> then(&[Map.fetch!(&1, :seeds), Map.delete(&1, :seeds)])
  end

  defp get_destination(source, mappings) do
    Enum.reduce(mappings, -1, fn [dest_s, src_s, rng], acc ->
      if source >= src_s and source <= src_s + rng,
        do: dest_s + (source - src_s),
        else: acc
    end)
    |> then(
      &if &1 != -1,
        do: &1,
        else: source
    )
  end

  defp parse_mapping(string), do: String.split(string, " ") |> Enum.map(&String.to_integer/1)

  defp parse_maps_or_seeds("seeds: " <> rest),
    do: %{:seeds => String.split(rest, " ") |> Enum.map(&String.to_integer/1)}

  defp parse_maps_or_seeds("seed-to-soil map:\n" <> rest),
    do: %{:seed_to_soil => String.split(rest, "\n") |> Enum.map(&parse_mapping/1)}

  defp parse_maps_or_seeds("soil-to-fertilizer map:\n" <> rest),
    do: %{:soil_to_fertilizer => String.split(rest, "\n") |> Enum.map(&parse_mapping/1)}

  defp parse_maps_or_seeds("fertilizer-to-water map:\n" <> rest),
    do: %{:fertilizer_to_water => String.split(rest, "\n") |> Enum.map(&parse_mapping/1)}

  defp parse_maps_or_seeds("water-to-light map:\n" <> rest),
    do: %{:water_to_light => String.split(rest, "\n") |> Enum.map(&parse_mapping/1)}

  defp parse_maps_or_seeds("light-to-temperature map:\n" <> rest),
    do: %{:light_to_temperature => String.split(rest, "\n") |> Enum.map(&parse_mapping/1)}

  defp parse_maps_or_seeds("temperature-to-humidity map:\n" <> rest),
    do: %{:temperature_to_humidity => String.split(rest, "\n") |> Enum.map(&parse_mapping/1)}

  defp parse_maps_or_seeds("humidity-to-location map:\n" <> rest),
    do: %{:humidity_to_location => String.split(rest, "\n") |> Enum.map(&parse_mapping/1)}
end
