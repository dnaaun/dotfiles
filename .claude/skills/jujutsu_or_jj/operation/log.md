---
description: "jj operation log - Show the operation log"
---

# jj operation log

Show the operation log.

Like other commands, `jj op log` snapshots the current working-copy changes and reconciles divergent operations. Use `--at-op=@ --ignore-working-copy` to inspect the current state without mutation.

## Usage

```
jj operation log [OPTIONS]
```

## Options

```
-n, --limit <LIMIT>         Limit number of operations to show

--reversed                  Show operations in the opposite order (older operations first)

--no-graph                  Don't show the graph, show a flat list of operations

-T, --template <TEMPLATE>   Render each operation using the given template

-d, --op-diff               Show changes to the repository at each operation

-p, --patch                 Show patch of modifications to changes (implies --op-diff)

-h, --help                  Print help
```
