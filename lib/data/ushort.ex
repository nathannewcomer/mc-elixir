defmodule Data.UShort do
  def parse(bytes) do
    <<short::integer-unsigned-size(16), rest::binary>> = bytes
    {short, rest}
  end

  def write(short) do
    <<short::integer-unsigned-size(16)>>
  end
end
