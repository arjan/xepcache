defmodule XepCacheTest do
  use ExUnit.Case
  doctest XepCache

  setup do
    XepCache.flush_all
  end

  test "get non-existing key" do
    assert nil == XepCache.get(:foo)
  end

  test "set a key and hold it for one second" do
    XepCache.set(:foo, 123, ttl: 1)
    assert 123 == XepCache.get(:foo)

    :timer.sleep 2000
    assert nil == XepCache.get(:foo)
  end

  test "flush all keys" do
    XepCache.set(:foo, :bar)
    XepCache.set(:baz, {1,2,3})
    assert :bar == XepCache.get :foo
    assert {1,2,3} == XepCache.get :baz
    XepCache.flush_all
    assert nil == XepCache.get :foo
    assert nil == XepCache.get :baz
  end

  test "flush single key" do
    XepCache.set(:foo, :bar)
    XepCache.set(:baz, {1,2,3})
    assert :bar == XepCache.get :foo
    assert {1,2,3} == XepCache.get :baz
    XepCache.flush :baz
    assert :bar == XepCache.get :foo
    assert nil == XepCache.get :baz
  end

  test "cache key dependencies" do
    XepCache.set(:child, "hello", deps: [:parent])
    assert "hello" == XepCache.get :child
    
    XepCache.flush :parent
    assert nil == XepCache.get :child
  end

  test "memo with anon function" do
    time_fn = fn() -> System.system_time end
    t = XepCache.memo(time_fn, :time_key)
    assert t == XepCache.memo(time_fn, :time_key)
    assert t == XepCache.memo(time_fn, :time_key)
  end

  # test "memo with MFA" do
  #   time_fn = {XepCacheTest, :some_function, []}
  #   t = XepCache.memo(time_fn)
  #   assert t == XepCache.memo(time_fn)
  #   assert t == XepCache.memo(time_fn)
  # end


  def some_function do
    System.system_time
  end

end
