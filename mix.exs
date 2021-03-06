defmodule Fastfwd.MixProject do
  use Mix.Project

  def project do
    [
      app: :fastfwd,
      version: "0.2.0",
      elixir: "~> 1.7",
      description: "Plugin style function forwarding in Elixir, for adapters, factories and other fun",
      package: package(),
      name: "Fastfwd",
      source_url: "https://github.com/Digital-Identity-Labs/fastfwd",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [
        tool: ExCoveralls
      ],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      docs: [
        main: "readme",
        #logo: "path/to/logo.png",
        extras: ["README.md"]
      ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:fastglobal, "~> 1.0"},
      {:apex, "~> 1.2", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.13", only: :test},
      {:benchee, "~> 1.0", only: [:dev, :test]},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:earmark, "~> 1.4", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_unit_assert_match, "~> 0.3", only: :test},
      {:ex_matchers, "~> 0.1.3", only: :test}
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/Digital-Identity-Labs/fastfwd"
      }
    ]
  end



end
