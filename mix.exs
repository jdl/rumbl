defmodule Rumbl.Mixfile do
  use Mix.Project

  def project do
    [app: :rumbl,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Rumbl, []},
     applications: [:phoenix, 
                    :phoenix_html, 
                    :cowboy, 
                    :logger,
                    :phoenix_ecto, 
                    :postgrex,
                    :comeonin]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
     {:phoenix, override: true, git: "git@github.com:phoenixframework/phoenix.git", branch: "master"},
     {:phoenix_ecto, "~> 1.1"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, override: true, git: "git@github.com:phoenixframework/phoenix_html.git"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:cowboy, "~> 1.0"},
     {:comeonin, "~> 1.0"},
     {:sweet_xml, "~> 0.5.0"}
    ]
  end
end
