# XepCache

A wrapper around Erlang's
[depcache](https://github.com/zotonic/depcache), an in-memory caching
server based on ETS.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add xepcache to your list of dependencies in `mix.exs`:

        def deps do
          [{:xepcache, "~> 0.0.1"}]
        end

  2. Ensure xepcache is started before your application:

        def application do
          [applications: [:xepcache]]
        end

