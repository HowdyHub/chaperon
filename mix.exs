defmodule Chaperon.Mixfile do
  use Mix.Project

  def project do
    [
      app: :chaperon,
      version: "0.1.3",
      elixir: "~> 1.5",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
      description: "An Elixir based HTTP load & performance testing framework",
      dialyzer: [
        plt_add_deps: :apps_direct,
        plt_add_apps: [
          :httpoison, :uuid, :poison, :histogrex
        ],
        flags: [
          # "-Woverspecs",
          # "-Wunderspecs"
        ],
        remove_defaults: [:unknown] # skip unkown function warnings
      ],
      # docs
      source_url: "https://github.com/polleverywhere/chaperon",
      docs: [
        extras: ["README.md"]
      ]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [
        :logger, :httpoison, :uuid, :poison, :histogrex, :websockex, :ssl,
        :crypto, :instream
      ],
      mod: {Chaperon, []}
    ]
  end

  defp package do
    [
      name: "chaperon",
      files: [
        "lib", "docs", "examples", "mix.exs", "README*", "LICENSE"
      ],
      maintainers: [
        "Christopher Bertels"
      ],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/polleverywhere/chaperon"
      }
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.11.1"},
      {:uuid, "~> 1.1"},
      {:poison, "~> 3.0"},
      {:histogrex, "~> 0.0.4"},
      {:websockex, "~> 0.2"},
      {:e_q, "~> 1.0.0"},
      {:instream, "~> 0.16.0"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.14", only: :dev},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false}
    ]
  end
end
