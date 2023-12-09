defmodule AttTest do
  use ExUnit.Case
  doctest Att

  test "greets the world" do
    assert Att.hello() == :world
  end
end
