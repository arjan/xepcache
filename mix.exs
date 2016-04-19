defmodule Depcache.Mixfile do
  use Mix.Project

  def project do
    [app: :xepcache,
     version: "1.0.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package,
     description: description,
     name: "XepCache"]
  end

  def application do
    [mod: {XepCache, []},
     applications: [:logger, :depcache]]
  end

  defp deps do
    [
      {:depcache, git: "https://github.com/zotonic/depcache.git", tag: "1.2.0"}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Arjan Scherpenisse"],
      licenses: ["Apache"],
      links: %{"GitHub" => "https://github.com/arjan/xepcache"}
    ]
  end

  defp description do
    """
    A wrapper around Erlang's depcache, an in-memory caching server.
    
    depcache bases its caching around ETS but can also switch to using
    the in-process dictionary for maintaining a process-local cache.
    Convenient functions are provided for getting/setting cache
    values, with ttl and cache key dependencies, as well as a memo
    function for caching the result of function executions.  
    """
  end

end
