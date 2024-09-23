import Bitwise

defmodule VarInt do
  @spec parse(nonempty_binary()) :: {integer(), binary()}
  def parse(bytes) do
    {result_bytes, rest} = read_internal(<<0>>, bytes)
    result_size = bit_size(result_bytes)
    <<result_num::integer-signed-size(result_size)>> = result_bytes

    {result_num, rest}
  end

  @spec read_internal(bitstring(), nonempty_binary()) :: {bitstring(), binary()}
  def read_internal(value, bytes) do
    <<flag::1, data::bitstring-size(7), rest::binary>> = bytes

    new_value = case value do
      <<0>> -> data
      _ -> <<data::bitstring, value::bitstring>>
    end

    # See if next value
    case flag do
      0 -> {new_value, rest}
      1 -> read_internal(new_value, rest)
    end
  end

  def write(number) when number >= 0, do: write_pos(number)
  def write(number) when number < 0, do: write_neg(number)

  defp write_pos(number) when number < 64, do: <<number>>
  defp write_pos(number), do: <<1::1, number::7, write_pos(number >>> 7)::binary>>

  defp write_neg(number) when number > -64, do: <<0::1, number::7>>
  defp write_neg(number), do: <<1::1, number::7, write_neg(number >>> 7)::binary>>
end
