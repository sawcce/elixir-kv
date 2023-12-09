defmodule Store do
  use GenServer

  def start_link(key) do
    GenServer.start_link(__MODULE__, key, name: String.to_atom(key))
  end

  @impl true
  def init(_key) do
    {:ok, %{test: "ok"}}
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    IO.inspect state
    val = Map.get(state, key)
    IO.inspect val
    {:reply, val, state}
  end

  @impl true
  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end
end
