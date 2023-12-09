defmodule WebInterface do
  use Plug.Router, restart: :permanent

  plug :match
  plug :dispatch

  get "/get/:bucket/:key" do
    val = GenServer.call(String.to_atom(bucket), {:get, String.to_atom(key)})
    send_resp(conn, 200, "#{val}")
  end

  post "/set/:bucket/:key" do
    {:ok, v, _} = Plug.Conn.read_body(conn)
    val = GenServer.cast(String.to_atom(bucket), {:put, String.to_atom(key), v})
    send_resp(conn, 200, "ok")
  end

  match _ do
    send_resp(conn, 404, "404 not found")
  end
end
