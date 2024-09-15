defmodule Protocol do
  def decode_request(request) do
    << length :: 8, rest :: bitstring >> = request
    << packet_id :: 8, array :: bitstring >> = rest

    case packet_id do
      0x00 -> handshake(length - 1, array)
    end
  end

  def handshake(length, array) do

  end
end
