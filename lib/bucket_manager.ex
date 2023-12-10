defmodule BucketManager do
  use GenServer

  def start_link(pid) do
    GenServer.start_link(__MODULE__, pid, name: __MODULE__)
  end

  @impl true
  def init(pid) do
    {:ok, pid}
  end

  @impl true
  def handle_call({:create, name}, _from, pid) do
    IO.inspect name
    DynamicSupervisor.start_child(pid, {Store, name})
    {:reply, :ok, pid}
  end

  @impl true
  def handle_call({:delete, name}, _from, pid) do
    IO.inspect GenServer.whereis(String.to_atom(name))
    {:reply, :ok, pid}
  end
end
