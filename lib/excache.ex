defmodule ExCache do
  use Application

  @default :depcache
  
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(:depcache, [@default, [memory_max: 512]])
    ]

    opts = [strategy: :one_for_one, name: ExCache.Supervisor]
    Supervisor.start_link(children, opts)
  end


  def get(key) do
    get(key, @default)
  end

  def get(key, server) do
    map_value(:depcache.get(key, server))
  end



  defp map_value(:undefined), do: nil
  defp map_value(value), do: value

end
