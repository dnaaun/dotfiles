---
description: "jj redo - Redo the most recently undone operation"
---

# jj redo

Redo the most recently undone operation.

This is the natural counterpart of `jj undo`. Repeated invocations of `jj undo` and `jj redo` act similarly to Undo/Redo commands in a text editor.

Use `jj op log` to visualize the log of past operations, including a detailed description of any past undo/redo operations. See also `jj op restore` to explicitly restore an older operation by its id.

## Usage

```
jj redo [OPTIONS]
```

## Options

```
-h, --help    Print help
```
