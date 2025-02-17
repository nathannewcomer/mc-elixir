defmodule Protocol.Handshake do
  def decode_handshake(byte_array) do
    # protocol version
    {protocol_version, rest} = Data.VarInt.parse(byte_array)

    # server address
    {address, rest} = Data.String.parse(rest)

    # server port
    {port, rest} = Data.UShort.parse(rest)

    # next state
    {next_state, _rest} = Data.VarInt.parse(rest)

    IO.puts("Protocol version: #{protocol_version}")
    IO.puts("Address: #{address}")
    IO.puts("Port: #{port}")
    IO.puts("Next state: #{next_state}")

    # # no response for this request
    # {:change_state, new_state}

    {protocol_version, address, port, next_state}
  end

  def process_handshake({_protocol_version, _address, _port, next_state}, client_socket) do
    new_state = case next_state do
      1 -> :status
      2 -> :login
      3 -> :transfer
    end

    IO.puts("Updating state to #{new_state}")
    :ok = McProtocol.client_state_put(client_socket, new_state)

    :no_response
  end
end
