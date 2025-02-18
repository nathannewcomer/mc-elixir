defmodule Protocol.Login do
  def decode(byte_array) do
    # Player username
    {name, rest} = Data.String.parse(byte_array)
    {uuid, _rest} = Data.UUID.parse(rest)

    {name, uuid}
  end

  def create_response({username, input_uuid}) do
    IO.puts("Player UUID: #{inspect(input_uuid)}")

    uuid = :erlang.md5("OfflinePlayer:TODO")
      |> Base.encode16(case: :lower)


  end
end
