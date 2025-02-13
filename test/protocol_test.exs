defmodule ProtocolTest do
  use ExUnit.Case
  use ExUnitProperties

  test "decode request" do
    input_bytes = <<16, 0, 255, 5, 9, 108, 111, 99, 97, 108, 104, 111, 115, 116, 15, 160, 2>>
    {length, packet_id, data} = McProtocol.decode_request(input_bytes, :handshaking)

    assert length == 16
    assert packet_id == 0x00
    assert data == {767, "localhost", 4000, 2}
  end

  # test "parse handshake" do
  #   input_bytes = <<16, 0, 255, 5, 9, 108, 111, 99, 97, 108, 104, 111, 115, 116, 15, 160, 2>>
  #   {length, packet_id, byte_array} = McProtocol.decode_request(input_bytes)

  #   assert length == 16
  #   assert packet_id = 0x00

  #   McProtocol.handle_request()
  #   #expected = {767, "localhost", 4000, 2}

  #   assert expected == parsed
  # end
end
