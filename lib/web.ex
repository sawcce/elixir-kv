defmodule WebInterface do
  use Plug.Router, restart: :permanent

  plug :match
  plug :dispatch

  get "/get/:bucket/:key" do
    bucket_id = String.to_atom(bucket)

    case GenServer.whereis(bucket_id) do
      nil ->
        send_resp(conn, 404, "Resource not found")
      pid ->
        val = GenServer.call(pid, {:get, String.to_atom(key)})
        send_resp(conn, 200, "#{val}")
      end
  end

  post "/set/:bucket/:key" do
    {:ok, v, _} = Plug.Conn.read_body(conn)
    bucket_id = String.to_atom(bucket)

    case GenServer.whereis(bucket_id) do
      nil ->
        GenServer.call(BucketManager, {:create, bucket})
        GenServer.cast(bucket_id, {:put, String.to_atom(key), v})
        send_resp(conn, 200, "ok, bucket created")
      pid ->
        GenServer.cast(pid, {:put, String.to_atom(key), v})
        send_resp(conn, 200, "ok")
    end
  end

  match _ do
    send_resp(conn, 404, "404 not found")
  end
end
