defmodule AdventOfCode2023.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent_of_code_2023,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      # this is the name of any module implementing the Application behaviour
     # mod: {AdventOfCode2023, []},
      applications: [:logger]
    ]
  end

  defp deps do
    [
      {:math, "~> 0.7.0"}
    ]
  end
end
