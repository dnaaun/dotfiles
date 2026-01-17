---
description: "jj undo - Undo the last operation"
---

# jj undo

Undo the last operation.

If used once after a normal (non-`undo`) operation, this will undo that last operation by restoring its parent. If `jj undo` is used repeatedly, it will restore increasingly older operations, going further back into the past.

There is also a complementary `jj redo` command that would instead move in the direction of the future after one or more `jj undo`s.

Use `jj op log` to visualize the log of past operations, including a detailed description of any past undo/redo operations. See also `jj op restore` to explicitly restore an older operation by its id.

## Usage

```
jj undo [OPTIONS] [OPERATION]
```

## Arguments

- `[OPERATION]` - (deprecated, use `jj op revert <operation>`) The operation to undo [default: @]

## Options

```
-h, --help    Print help
```
