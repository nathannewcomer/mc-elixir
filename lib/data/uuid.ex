defmodule Data.UUID do
  def parse(bytes) do
    <<uuid::binary-16, rest::binary>> = bytes
    {uuid |> Base.encode16(), rest}
  end

  def write(uuid) do
    :TODO
  end
end
