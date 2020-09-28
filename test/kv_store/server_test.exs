defmodule KVStore.ServerTest do
  use ExUnit.Case
  alias KVStore.Server

  test "run_command SET sets value for key" do
    assert nil == Server.run_command("SET", "foo", "bar")
  end

  test "run_command GET gets value for key" do
    Server.run_command("SET", "foo", "bar")
    assert "bar" = Server.run_command("GET", "foo")
  end

  test "run_command DELETE deletes key" do
    Server.run_command("SET", "foo", "bar")
    assert nil == Server.run_command("DELETE", "foo")
  end

  test "run_command COUNT counts occurrences of value" do
    Server.run_command("SET", "foo", 1)
    Server.run_command("SET", "bar", 1)
    Server.run_command("SET", "baz", 1)
    assert 3 = Server.run_command("COUNT", 1)
  end

  test "can begin transactions" do
    assert nil == Server.run_command("BEGIN")
  end

  test "can rollback transactions" do
    Server.run_command("BEGIN")
    assert nil == Server.run_command("ROLLBACK")
  end

  test "can commit transactions" do
    Server.run_command("BEGIN")
    assert nil == Server.run_command("COMMIT")
  end

  test "can access updated values inside transaction and old value after rollback" do
    Server.run_command("SET", "foo", 1)
    assert 1 = Server.run_command("GET", "foo")
    Server.run_command("BEGIN")
    Server.run_command("SET", "foo", 2)
    assert 2 = Server.run_command("GET", "foo")
    Server.run_command("ROLLBACK")
    assert 1 = Server.run_command("GET", "foo")
  end
end
