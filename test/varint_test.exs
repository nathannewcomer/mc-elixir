defmodule VarIntTest do
  use ExUnit.Case
  use ExUnitProperties

  test "parse VarInt" do
    check all number <- StreamData.integer(), [max_runs: 1_000_000] do
      {parsed, _rest} = VarInt.write(number) |> VarInt.parse()
      assert number == parsed
    end
  end
end
