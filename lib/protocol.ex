defmodule McProtocol do
  def decode_request(request) do
    {length, rest} = VarInt.parse(request)
    {packet_id, byte_array} = rest

    case packet_id do
      0x00 -> handshake(length - 1, byte_array)
    end
  end

  def handshake(length, byte_array) do
    # protocol version
    {protocol_version, rest} = VarInt.parse(byte_array)

    # server address


    # server port

    # next state
  end
end
