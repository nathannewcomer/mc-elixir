defmodule ProtocolTest do
  use ExUnit.Case
  use ExUnitProperties

  test "RSA encrypt/decrypt" do
    check all string <- StreamData.string(:utf8, min_length: 1) do
      {public_key, private_key} = McProtocol.generate_key_pair()
      final_string =
        McProtocol.encrypt(string, public_key)
        |> McProtocol.decrypt(private_key)

        assert string == final_string
    end
  end

  test "decode request" do
    input_bytes = <<16, 0, 255, 5, 9, 108, 111, 99, 97, 108, 104, 111, 115, 116, 15, 160, 2>>
    {length, rest} = Data.VarInt.parse(input_bytes)
    {packet_id, data} = McProtocol.decode_request(rest, :handshaking)

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
