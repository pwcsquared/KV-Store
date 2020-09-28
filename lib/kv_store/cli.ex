defmodule KVStore.CLI do
  @switches []
  @no_arg_commands ["BEGIN", "COMMIT", "ROLLBACK"]
  @one_arg_commands ["GET", "DELETE", "COUNT"]
  @two_arg_commands ["SET"]

  def main(_) do
    await_command()
  end

  defp await_command do
    IO.gets("")
    |> process_command()
  end

  defp process_command(command) do
    command
    |> String.trim()
    |> OptionParser.split()
    |> OptionParser.parse(strict: @switches)
    |> execute_command()
  end

  defp execute_command({[], [command], []}) when command in @no_arg_commands do
    IO.puts("received command #{command}")
    await_command()
  end

  defp execute_command({[], [command, arg], []}) when command in @one_arg_commands do
    IO.puts("received command #{command}, with args #{arg}")
    await_command()
  end

  defp execute_command({[], [command, arg1, arg2], []}) when command in @two_arg_commands do
    IO.puts("received command #{command}, with args #{arg1}, #{arg2}")
    await_command()
  end

  defp execute_command(_) do
    IO.puts("invalid command")
    await_command()
  end
end
