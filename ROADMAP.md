# Roadmap

## If I had more time

The first thing that is lacking is test coverage, especially of the `KVStore.CLI` module. Most functionality of `KVStore.Store` is tested through Server tests, but those are fairly limited to the happy paths.

There are also some implementation details of the CLI leaking into GenServer implementation, I would probably replace the funtion `run_command` with command specific functions (i.e. `get`, `set`, `commit`, etc.) and leave it to the CLI module to call the correct ones.

I also neglected to create a supervisor module when I first generated the project, so right now the GenServer is started from mix.exs when it should really be underneath a sup.

As far as implementation details go, the way I handled transactions is to copy the most recent existing store state, append to the head of the list, and read/write to that map until it is either committed or rolled back. On commit, this transactional copy replaces the second store in the list. On rollback, this copy is simply deleted. This approach makes keeping track of `DELETE`s in a transaction pretty simple, at the cost of more memory usage than a diff-based approach. If stores are large or nest transactions are expected to be common and/or long-running, it might make sense to reimplement these functions of `Store` as diffs instead.
