defmodule Bkdrf.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bkdrf,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1"},
      {:html_entities, "~> 0.3"},
      {:html_sanitize_ex, "~> 1.3.0"},
      {:floki, "~> 0.20.0"}
    ]
  end
end
