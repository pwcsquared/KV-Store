defmodule KVStore.CLI do
  @switches []

  def main(_) do
    await_command()
  end

  defp await_command do
    IO.gets("")
    |> process_command()
  end

  def process_command(command) do
    command
    |> String.trim()
    |> OptionParser.split()
    |> OptionParser.parse(strict: @switches)
    |> execute_command()
  end

  defp execute_command({[], ["quit"], []}) do
    IO.puts "quitting..."
  end

  defp execute_command({[], [command], []}) do
    IO.puts "received command #{command}"
    await_command()
  end

  defp execute_command({[], [command, arg], []}) do
    IO.puts "received command #{command}, with args #{arg}"
    await_command()
  end
end
