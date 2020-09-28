defmodule KVStore.Server do
  use GenServer

  alias KVStore.Store

  def start(_, opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def run_command("SET", key, value) do
    GenServer.call(__MODULE__, {:set, key, value})
  end

  def run_command("GET", key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def run_command("DELETE", key) do
    GenServer.call(__MODULE__, {:delete, key})
  end

  def run_command("COUNT", key) do
    GenServer.call(__MODULE__, {:count, key})
  end

  def run_command("BEGIN") do
    GenServer.call(__MODULE__, :begin)
  end

  def run_command("COMMIT") do
    GenServer.call(__MODULE__, :commit)
  end

  def run_command("ROLLBACK") do
    GenServer.call(__MODULE__, :rollback)
  end

  @impl true
  def init(_) do
    {:ok, Store.new()}
  end

  @impl true
  def handle_call({:set, key, value}, _from, state) do
    with {:ok, new_state} <- Store.set(state, key, value) do
      {:reply, nil, new_state}
    else
      _ -> {:reply, :error, state}
    end
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    with {:ok, value} <- Store.get(state, key) do
      {:reply, value, state}
    else
      _ -> {:reply, :error, state}
    end
  end

  @impl true
  def handle_call({:delete, key}, _from, state) do
    with {:ok, new_state} <- Store.delete(state, key) do
      {:reply, nil, new_state}
    else
      _ -> {:reply, :error, state}
    end
  end

  @impl true
  def handle_call({:count, key}, _from, state) do
    with {:ok, count} <- Store.count(state, key) do
      {:reply, count, state}
    else
      _ -> {:reply, :error, state}
    end
  end

  @impl true
  def handle_call(:begin, _from, state) do
    with {:ok, new_state} <- Store.begin_transaction(state) do
      {:reply, nil, new_state}
    else
      _ -> {:reply, :error, state}
    end
  end

  @impl true
  def handle_call(:commit, _from, state) do
    with {:ok, new_state} <- Store.commit_transaction(state) do
      {:reply, nil, new_state}
    else
      _ -> {:reply, :error, state}
    end
  end

  @impl true
  def handle_call(:rollback, _from, state) do
    with {:ok, new_state} <- Store.rollback_transaction(state) do
      {:reply, nil, new_state}
    else
      _ -> {:reply, :error, state}
    end
  end
end
