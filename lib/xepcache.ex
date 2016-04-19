defmodule XepCache do
  @moduledoc """
  A wrapper around Erlang's depcache, an in-memory caching server.
  
  depcache bases its caching around ETS but can also switch to using
  the in-process dictionary for maintaining a process-local cache.
  Convenient functions are provided for getting/setting cache
  values, with ttl and cache key dependencies, as well as a memo
  function for caching the result of function executions.  

  ## Options
  
  Most functions take an `opts` argument which holds various options.

  * `:ttl` - the maximum time-to-live of the cached value. When the
    cached value is older than the time, it will be marked as expired.

  * `:deps` - an array of cache keys which the given key depends
    on. This can be used to invalidate an entire tree of keys just by
    flushing one "parent" key on which these all depend.

  * `:server` - the name of the depcache server. By default, the
  `xepcache` application starts a single depcache instance, registered
  under the default name `:depcache`.  This is also the default
  argument for this option, so it can be omitted usually.

  """

  use Application

  @default :depcache
  @default_ttl 3600
  
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(:depcache, [@default, [memory_max: 512]])
    ]

    opts = [strategy: :one_for_one, name: XepCache.Supervisor]
    Supervisor.start_link(children, opts)
  end


  def get(key), do: get(key, [server: @default])
  @doc """
  Fetch the key from the cache, return the data or nil if not found.
  """
  def get(key, opts) do
    return_value(:depcache.get(key, server(opts)))
  end

  def set(key, value), do: set(key, value, [server: @default])
  @doc """
  Add a key to the depcache with a given value. :ttl option gives the maximum key expiry; :deps option gives an array of cache keys which this key depends on.
  """
  def set(key, value, opts) do
    return_value(:depcache.set(key, value, ttl(opts), deps(opts), server(opts)))
  end

  def flush_all(), do: flush_all(@default)
  @doc """
  Flush all keys from the caches for given server or the default server
  """
  def flush_all(server) do
    :depcache.flush(server)
  end

  def flush(key), do: flush(key, server: @default)
  @doc """
  Flush the key and all keys depending on the key
  """
  def flush(key, opts) do
    :depcache.flush(key, server(opts))
  end

  @doc """
  Check if we use a local process dict cache
  """
  def in_process(), do: :depcache.in_process

  @doc """
  Enable or disable the in-process caching using the process dictionary
  """
  def in_process(flag), do: :depcache.in_process(flag)


  def memo(fun), do: memo(fun, nil, server: @default)
  def memo(fun, key), do: memo(fun, key, server: @default)
  @doc """
  Adds the result of the given function to the depcache. The function is only called when there is a cache miss; otherwise, the cached value is returned.
  """
  def memo(fun, key, opts) do
    :depcache.memo(fun, param(key || opts[:key]), ttl(opts), deps(opts), server(opts))
  end
  
  defp server(opts), do: opts[:server] || @default
  defp ttl(opts), do: opts[:ttl] || @default_ttl
  defp deps(opts), do: opts[:deps] || []

  defp return_value(:undefined), do: nil
  defp return_value(:ok), do: :ok
  defp return_value({:ok, value}), do: value

  defp param(nil), do: :undefined
  defp param(value), do: value

end
