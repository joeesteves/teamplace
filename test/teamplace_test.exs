defmodule TeamplaceTest do
  use ExUnit.Case
  doctest Teamplace

  test "greets the world" do
    assert Teamplace.hello() == :world
  end
end
