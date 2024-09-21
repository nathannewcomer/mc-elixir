defmodule McString do
  def parse(bytes) do
    # Get size as VarInt
    {size, rest} = VarInt.parse(bytes)

    # Read size bytes
    <<string::binary-size(size), rest>> = rest

    {string, rest}
  end
end
