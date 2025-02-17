defmodule McProtocol do
  def decode_request(request, state) do
    # length is consumed by read_request()
    {packet_id, byte_array} = Data.VarInt.parse(request)

    data = case {state, packet_id} do
      # login
      {:handshaking, 0x00} -> Protocol.Handshake.decode_handshake(byte_array)
      {:login, 0x00} -> Protocol.Login.decode(byte_array)
      _ -> IO.puts("New message found\n")
    end

    IO.puts("decoding #{state} - #{packet_id}")

    {packet_id, data}
  end

  def server_update({packet_id, data}, state, client_socket) do
    case {state, packet_id} do
      # login
      {:handshaking, 0x00} -> Protocol.Handshake.process_handshake(data, client_socket)
      {:login, 0x00} -> Protocol.Login.create_response()
    end
  end

  def generate_key_pair() do
    {public_key, private_key} = :crypto.generate_key(:rsa, {1024, 65537})
    {public_key, private_key}
  end

  def encrypt(byte_array, public_key) do
    :crypto.public_encrypt(:rsa, byte_array, public_key, :rsa_pkcs1_padding)
  end

  def decrypt(encrypted_bytes, private_key) do
    :crypto.private_decrypt(:rsa, encrypted_bytes, private_key, :rsa_pkcs1_padding)
  end

  def client_state_get(client_socket) do
    state = Agent.get(:client_state, fn map ->
      Map.get(map, client_socket) end)

    state
  end

  def client_state_put(client_socket, state) do
    Agent.update(:client_state, fn map -> Map.put(map, client_socket, state) end)
  end
end
