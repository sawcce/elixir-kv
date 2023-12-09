defmodule GreetWorker do
  use GenServer

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: String.to_atom(arg))
  end

  @impl true
  def init(greeting \\ "aloha") do
    {:ok, greeting}
  end

  @impl true
  def handle_call({:greet, person}, _from, state) do
    IO.puts state <> " " <> person
    {:reply, :ok, state}
  end
end
