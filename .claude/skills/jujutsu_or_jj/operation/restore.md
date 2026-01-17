---
description: "jj operation restore - Create a new operation that restores the repo to an earlier state"
---

# jj operation restore

Create a new operation that restores the repo to an earlier state.

This restores the repo to the state at the specified operation, effectively undoing all later operations. It does so by creating a new operation.

## Usage

```
jj operation restore [OPTIONS] <OPERATION>
```

## Arguments

- `<OPERATION>` - The operation to restore to. Use `jj op log` to find an operation.

## Options

```
--what <WHAT>   What portions of the local state to restore (can be repeated)
                [possible values: repo, remote-tracking]
                [default: repo remote-tracking]

-h, --help      Print help
```
