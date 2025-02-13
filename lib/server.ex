defmodule Server do
  def start(port) do
    {:ok, listen_socket} = :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])

    IO.puts("Server running on #{port}...\n")

    {:ok, _pid} = Agent.start_link(fn -> %{} end, name: :client_state)

    accept_connection(listen_socket)
  end

  def accept_connection(listen_socket) do
    # get connection
    IO.puts("waiting for connection...\n")
    {:ok, client_socket} = :gen_tcp.accept(listen_socket)
    IO.puts("Connection accepted!\n")

    # set initial client state
    McProtocol.client_state_put(client_socket, :handshaking)

    # process connection on new process
    pid = spawn(fn -> process_request(client_socket) end)
    :ok = :gen_tcp.controlling_process(client_socket, pid)
    IO.puts("Processing at PID: #{inspect(pid)}\n")

    accept_connection(listen_socket)
  end

  def process_request(client_socket) do
    IO.puts("Processing request...\n")
    IO.puts("Client socket = #{inspect(client_socket)}")

    state = McProtocol.client_state_get(client_socket)

    # read, then process request
    next = client_socket
      |> read_request()
      |> McProtocol.decode_request(state)
      |> McProtocol.server_update(state, client_socket)

    IO.puts("next = #{inspect(next)}")

    # write response if applicable
    case next do
      :next_request -> process_request(client_socket)
      _ -> IO.puts("Next is not covered")
    end

  end

  def read_request(client_socket) do
    {:ok, request} = :gen_tcp.recv(client_socket, 0)
    IO.puts("Raw request: #{inspect(request)}")

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
