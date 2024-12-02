defmodule DayoneTest do
  use ExUnit.Case
  doctest Dayone

  test "greets the world" do
    assert Dayone.hello() == :world
  end
end
