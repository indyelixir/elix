defmodule Elix.Mixfile do
  use Mix.Project

  def project do
    [app: :elix,
     version: "0.1.0",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      mod: {Elix, []},
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

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
      {:hedwig, "~> 1.0"},
      {:hedwig_flowdock, github: "stevegrossi/hedwig_flowdock"},
      {:hedwig_giphy, "~> 0.1"},
      {:redix, "~> 0.4"},
      {:honeybadger, "~> 0.1", only: [:prod]},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:mix_test_watch, "~> 0.2", only: :dev}
    ]
  end
end
