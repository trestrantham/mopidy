defmodule Mopidy.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mopidy,
      version: "0.0.1",
      elixir: "~> 1.2",
      description: "A Mopidy Library for Elixir",
      package: package,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(Mix.env),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test]
    ]
  end

  def application do
    [
      applications: [
        :httpotion,
      ],
      mod: {Mopidy, []}
    ]
  end

  defp deps(:dev) do
    deps(:prod)
  end

  defp deps(:test) do
    deps(:dev)
  end

  defp deps(:prod) do
    [
      {:excoveralls, "~> 0.4", only: :test},
      {:httpotion, "~> 3.0.0"},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:poison, "~> 2.1"}
    ]
  end

  def package do
    [
      maintainers: ["Tres Trantham"],
      licenses: ["New BSD"],
      links: %{"GitHub" => "https://github.com/trestrantham/mopidy"}
    ]
  end
end
