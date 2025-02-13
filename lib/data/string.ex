defmodule Data.String do
  def parse(bytes) do
    # Get size as VarInt
    {size, rest} = Data.VarInt.parse(bytes)

    # Read size bytes
    <<string::binary-size(size), rest::binary>> = rest

    {string, rest}
  end

  def write(string) do
    size_varint = byte_size(string) |> Data.VarInt.write()
    size_varint <> string
  end
end
