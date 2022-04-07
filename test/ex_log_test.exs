defmodule ExLogTest do
  use ExUnit.Case
  doctest ExLog

  test "greets the world" do
    assert ExLog.hello() == :world
  end
end
