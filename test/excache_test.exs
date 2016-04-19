defmodule ExCacheTest do
  use ExUnit.Case
  doctest ExCache

  test "get / set" do
    assert nil == ExCache.get(:foo)
  end
  
end
