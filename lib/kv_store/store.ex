defmodule KVStore.Store do
  @moduledoc """
  Functions for altering the store.
  All function should return an {:ok, value} tuple on success.
  """

  @doc """
  Initializes key-value server store.

  The server state is a list of state history where the head is either a transaction in progress or the root-level store.
  """
  def new do
    [%{}]
  end

  def set([store | history], key, value) do
    new_store = Map.put(store, key, value)
    {:ok, [new_store | history]}
  end

  def get([store | _], key) do
    Map.fetch(store, key)
  end

  def delete([store | history], key) do
    if Map.has_key?(store, key) do
      new_store = Map.delete(store, key)
      {:ok, [new_store | history]}
    else
      :error
    end
  end

  def count([store | _], value) do
    count =
      Enum.count(store, fn {_key, val} ->
        val == value
      end)

    {:ok, count}
  end

  @doc """
  Copies the current head of store into a new map for altering.
  """
  def begin_transaction(history = [store | _]) do
    {:ok, [store | history]}
  end

  @doc """
  Commits the transaction by replacing the head of the story history list with the current state.

  If the history list has only 1 item, there is no current transaction and returns an error.
  """
  def commit_transaction([_current | []]) do
    :error
  end

  def commit_transaction([current | [_ | history]]) do
    {:ok, [current | history]}
  end

  @doc """
  Removes the transaction by removing the head of the store list.

  If the history list has only 1 item, there is no current transaction and returns an error.
  """
  def rollback_transaction([_current | []]) do
    :error
  end

  def rollback_transaction([_current | history]) do
    {:ok, history}
  end
end
