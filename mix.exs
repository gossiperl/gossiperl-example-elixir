defmodule GossiperlExampleElixir.Mixfile do
  use Mix.Project

  def project do
    [app: :gossiperl_example_elixir,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [ {:gossiperl_client, git: "https://github.com/gossiperl/gossiperl-client-erlang.git", tag: "1.0.0"} ]
  end
end