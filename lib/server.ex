defmodule Server do
  def start(port) do
    {:ok, listen_socket} = :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])

    IO.puts("Server running on #{port}...\n")

    accept_connection(listen_socket)
  end

  def accept_connection(listen_socket) do
    IO.puts("waiting for connection...\n")
    {:ok, client_socket} = :gen_tcp.accept(listen_socket)
    IO.puts("Connection accepted!\n")

    pid = spawn(fn -> process_request(client_socket) end)
    IO.puts("Processing at PID: #{inspect(pid)}\n")

    :ok = :gen_tcp.controlling_process(client_socket, pid)

    accept_connection(listen_socket)
  end

  def process_request(client_socket) do
    IO.puts("Processing request...\n")

    client_socket
    |> read_request
    |> create_response
    |> write_response(client_socket)
  end

  def read_request(client_socket) do
    {:ok, request} = :gen_tcp.recv(client_socket, 0)

    request
  end

  def create_response(request) do
    # Packet format
    # Length - VarInt
    # Packet ID - VarInt
    # Data - Byte Array

    # Match packet ID


    IO.puts(inspect(request))
    ""
  end

  def write_response(response, client_socket) do
    :ok = :gen_tcp.send(client_socket, response)

    IO.puts("[#{inspect(self())}] Response:\n\n#{response}")

    :gen_tcp.close(client_socket)
  end
end
