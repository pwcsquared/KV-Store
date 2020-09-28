defmodule KVStore.Store do
  use Agent

  @doc """
  Initializes key-value agent store.

  The agent state is a list of state history where the head is either a transaction in progress or the root-level store.
  """
  def start(_, _) do
    Agent.start_link(fn -> [%{}] end, name: __MODULE__)
  end

  def run_command("SET", key, value) do
    Agent.update(__MODULE__, &set(&1, key, value))
  end

  def run_command("GET", key) do
    Agent.get(__MODULE__, &get(&1, key))
  end

  def run_command("DELETE", key) do
    Agent.update(__MODULE__, &delete(&1, key))
  end

  def run_command("COUNT", value) do
    Agent.get(__MODULE__, &count(&1, value))
  end

  def run_command("BEGIN") do
    Agent.update(__MODULE__, &begin_transaction(&1))
  end

  def run_command("COMMIT") do
    Agent.update(__MODULE__, &commit_transaction(&1))
  end

  def run_command("ROLLBACK") do
    Agent.update(__MODULE__, &rollback_transaction(&1))
  end

  defp set([store | history], key, value) do
    new_store = Map.put(store, key, value)
    [new_store | history]
  end

  defp get([store | _], key) do
    Map.fetch(store, key)
  end

  defp delete([store | history], key) do
    case Map.fetch(store, key) do
      {:ok, _value} ->
        new_store = Map.delete(store, key)
        [new_store | history]

      :error ->
        :error
    end
  end

  defp count([store | _], value) do
    Enum.count(store, fn {_key, val} ->
      val == value
    end)
  end

  defp begin_transaction(history = [store | _]) do
    [store | history]
  end

  defp commit_transaction([current | [_, history]]) do
    [current | history]
  end

  defp rollback_transaction([current | history]) do
    history
  end
end
