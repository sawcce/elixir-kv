defmodule Att do
  require Logger

  def start(_type, _args) do
    {:ok, pid} = DynamicSupervisor.start_link(strategy: :one_for_one)

    webserver = {Plug.Cowboy, plug: WebInterface, scheme: :http, options: [ip: {0, 0, 0, 0}, port: 4000]}

    DynamicSupervisor.start_child(pid, {BucketManager, pid})
    DynamicSupervisor.start_child(pid, webserver)

    IO.puts "Supervised instances:"

    Enum.each Supervisor.which_children(pid), fn(item) ->
        {_, pid, role, instance} = item
        Logger.info("[Supervised] Role: #{role}, PID: #{inspect(pid)}, #{inspect(instance)}")
    end

    Process.sleep(:infinity)

    {:ok, pid}
  end
end
