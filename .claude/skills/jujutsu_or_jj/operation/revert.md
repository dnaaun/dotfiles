---
description: "jj operation revert - Create a new operation that reverts an earlier operation"
---

# jj operation revert

Create a new operation that reverts an earlier operation.

This reverts an individual operation by applying the inverse of the operation.

## Usage

```
jj operation revert [OPTIONS] [OPERATION]
```

## Arguments

- `[OPERATION]` - The operation to revert. Use `jj op log` to find an operation. [default: @]

## Options

```
--what <WHAT>   What portions of the local state to restore (can be repeated)
                [possible values: repo, remote-tracking]
                [default: repo remote-tracking]

-h, --help      Print help
```
