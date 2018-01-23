defmodule Mopidy.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mopidy,
      version: "0.3.0",
      elixir: ">= 1.3.0",
      deps: deps(),
      description: description(),
      package: package(),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
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
      {:dogma, "~> 0.1", only: :dev},
      {:earmark, "~> 1.2", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
      {:excoveralls, "~> 0.4", only: :test},
      {:httpotion, "~> 3.0"},
      {:mix_test_watch, "~> 0.2", only: :test},
      {:poison, "~> 3.1"},
      {:socket, "~> 0.3"}
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
