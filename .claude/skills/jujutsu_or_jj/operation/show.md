---
description: "jj operation show - Show changes to the repository in an operation"
---

# jj operation show

Show changes to the repository in an operation.

## Usage

```
jj operation show [OPTIONS] [OPERATION]
```

## Arguments

- `[OPERATION]` - Show repository changes in this operation, compared to its parent(s) [default: @]

## Options

```
--no-graph                Don't show the graph, show a flat list of modified changes

-T, --template <TEMPLATE> Render the operation using the given template

-p, --patch               Show patch of modifications to changes

--no-op-diff              Do not show operation diff

-h, --help                Print help
```

## Diff Formatting Options

```
-s, --summary               For each path, show only whether it was modified, added, or deleted
--stat                      Show a histogram of the changes
--types                     For each path, show only its type before and after
--name-only                 For each path, show only its path
--git                       Show a Git-format diff
--color-words               Show a word-level diff with changes indicated only by color
--tool <TOOL>               Generate diff by external command
--context <CONTEXT>         Number of lines of context to show
--ignore-all-space          Ignore whitespace when comparing lines
--ignore-space-change       Ignore changes in amount of whitespace
```
