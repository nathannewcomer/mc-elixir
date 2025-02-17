defmodule Protocol.Login do
  def decode(byte_array) do
    # Player username
    {name, rest} = Data.String.parse(byte_array)
    {uuid, _rest} = Data.UUID.parse(rest)

    {name, uuid}
  end

  def create_response() do
    # TODO do this leater
    {:response, "Hello world!"}
  end
end
