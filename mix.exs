defmodule Teamplace.MixProject do
  use Mix.Project

  def project do
    [
      app: :teamplace,
      version: "0.3.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Teamplace API Wrapper",
      source_url: "https://github.com/ponyesteves/teamplace"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Teamplace.Application, []},
      env: [
        query_prefix: "PARAMWEBREPORT_"
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:httpoison, "~> 1.2"},
      {:poison, "~> 3.0"},
      {:ex_doc, "~> 0.20.0", only: :dev, runtime: false},
      {:decimal, "~> 1.0"}
    ]
  end
end
