defmodule Depcache.Mixfile do
  use Mix.Project

  def project do
    [app: :excache,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [mod: {ExCache, []},
     applications: [:logger, :depcache]]
  end

  defp deps do
    [
      {:depcache, git: "https://github.com/zotonic/depcache.git", branch: "master"}
    ]
  end
end
