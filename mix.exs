defmodule Mopidy.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mopidy,
      version: "0.1",
      elixir: ">= 1.3.0-rc.1",
      deps: deps,
      description: description,
      package: package,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test
      ],
      docs: [main: Mopidy]
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

  defp deps do
    [
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:earmark, "~> 0.1", only: :docs},
      {:ex_doc, "~> 0.11", only: :docs},
      {:excoveralls, "~> 0.4", only: :test},
      {:httpotion, "~> 3.0.0"},
      {:inch_ex, "~> 0.4", only: :docs},
      {:mix_test_watch, "~> 0.2", only: :test},
      {:poison, "~> 2.1"}
    ]
  end

  defp description do
    """
    A Mopidy client library for Elixir
    """
  end

  defp package do
    [
      maintainers: ["Tres Trantham"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/trestrantham/mopidy"}
    ]
  end
end
