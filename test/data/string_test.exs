defmodule StringTest do
  use ExUnit.Case
  use ExUnitProperties

  test "parse String" do
    check all string <- StreamData.string(:utf8, min_length: 1) do
      {parsed, _rest} = Data.String.write(string) |> Data.String.parse()
      assert string == parsed
    end
  end
end
