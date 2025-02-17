defmodule Data.UUID do
  def parse(bytes) do
    <<uuid::integer-unsigned-size(16), rest::binary>> = bytes
    {uuid, rest}
  end

  def write(uuid) do
    <<uuid::integer-unsigned-size(16)>>
  end
end
