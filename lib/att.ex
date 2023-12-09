defmodule Att do
  def start(_type, _args) do
    {:ok, pid} = DynamicSupervisor.start_link(strategy: :one_for_one)

    webserver = {Plug.Cowboy, plug: WebInterface, scheme: :http, options: [port: 4000]}

    DynamicSupervisor.start_child(pid, webserver)
    DynamicSupervisor.start_child(pid, {Store, "main"})

    IO.puts "Workers:"
    IO.inspect Supervisor.which_children(pid)

    Process.sleep(:infinity)

    {:ok, pid}
  end
end
