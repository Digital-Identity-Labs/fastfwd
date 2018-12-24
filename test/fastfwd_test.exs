defmodule FastfwdTest do
  use ExUnit.Case
  doctest Fastfwd

  test "greets the world" do
    assert Fastfwd.hello() == :world
  end
end
