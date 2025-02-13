defmodule McProtocol do
  def decode_request(request, state) do
    {length, rest} = Data.VarInt.parse(request)
    {packet_id, byte_array} = Data.VarInt.parse(rest)

    IO.puts("decoding with state #{state}")
    data = case {state, packet_id} do
      {:handshaking, 0x00} -> decode_handshake(byte_array)
      _ -> IO.puts("New message found")
    end

    IO.puts("Sending #{inspect({length, packet_id, data})}")
    {length, packet_id, data}
  end

  def server_update({_length, packet_id, data}, state, client_socket) do
    IO.puts("server_update data = #{inspect(data)}")
    case {state, packet_id} do
      {:handshaking, 0x00} -> process_handshake(data, client_socket)
    end
  end

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
    :ok = client_state_put(client_socket, new_state)

    :next_request
  end

  def read_again?({_protocol_version, _address, _port, _next_state}), do: true
  def read_again?(_request), do: false

  def client_state_get(client_socket) do
    state = Agent.get(:client_state, fn map ->
      IO.puts("Map = #{inspect(map)}")
      Map.get(map, client_socket) end)
    IO.puts("Retrieved #{state}")

    state
  end

  def client_state_put(client_socket, state) do
    IO.puts("Inserting #{state}")
    Agent.update(:client_state, fn map -> Map.put(map, client_socket, state) end)
  end
end
