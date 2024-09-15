defmodule Data do
  @spec parse_varint(nonempty_binary()) :: {integer(), binary()}
  def parse_varint(bytes) do
    {result_bytes, rest} = varint_read(<<0>>, bytes)
    result_size = bit_size(result_bytes)
    <<result_num::integer-signed-size(result_size)>> = result_bytes

    {result_num, rest}
  end

  @spec varint_read(bitstring(), nonempty_binary()) :: {bitstring(), binary()}
  def varint_read(value, bytes) do
    <<flag::1, data::bitstring-size(7), rest::binary>> = bytes

    new_value = case value do
      <<0>> -> data
      _ -> <<data::bitstring, value::bitstring>>
    end

    # See if next value
    case flag do
      0 -> {new_value, rest}
      1 -> varint_read(new_value, rest)
    end
  end

  def varint_write() do

  end
end
