defmodule McServerTest do
  use ExUnit.Case
  doctest McServer

  test "greets the world" do
    assert McServer.hello() == :world
  end
end
