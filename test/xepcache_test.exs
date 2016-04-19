defmodule XepCacheTest do
  use ExUnit.Case
  doctest XepCache

  test "get / set" do
    assert nil == XepCache.get(:foo)
  end
  
end
