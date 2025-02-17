defmodule UShortTest do
  use ExUnit.Case
  use ExUnitProperties

  test "parse UUID" do
    check all number <- StreamData.integer(0, Integer.pow(2, 128) - 1) do
      {parsed, _rest} = Data.UUID.write(number) |> Data.UUID.parse()
      assert number == parsed
    end
  end
end
