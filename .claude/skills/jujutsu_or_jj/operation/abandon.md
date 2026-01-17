---
description: "jj operation abandon - Abandon operation history"
---

# jj operation abandon

Abandon operation history.

To discard old operation history, use `jj op abandon ..<operation ID>`. It will abandon the specified operation and all its ancestors. The descendants will be reparented onto the root operation.

To discard recent operations, use `jj op restore <operation ID>` followed by `jj op abandon <operation ID>..@-`.

Previous versions of a change (or predecessors) are also discarded if they become unreachable from the operation history. The abandoned operations, commits, and other unreachable objects can later be garbage collected by using `jj util gc` command.

## Usage

```
jj operation abandon [OPTIONS] <OPERATION>
```

## Arguments

- `<OPERATION>` - The operation or operation range to abandon

## Options

```
-h, --help    Print help
```
