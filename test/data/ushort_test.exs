defmodule UShortTest do
  use ExUnit.Case
  use ExUnitProperties

  test "parse UShort" do
    check all number <- StreamData.integer(0..65535) do
      {parsed, _rest} = Data.UShort.write(number) |> Data.UShort.parse()
      assert number == parsed
    end
  end
end
