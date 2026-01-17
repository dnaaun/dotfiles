---
description: "jj show - Show commit description and changes in a revision"
---

# jj show

Show commit description and changes in a revision.

## Usage

```
jj show [OPTIONS] [REVSET]
```

## Arguments

- `[REVSET]` - Show changes in this revision, compared to its parent(s) [default: @]

## Options

```
-T, --template <TEMPLATE>   Render a revision using the given template

--no-patch                  Do not show the patch

-h, --help                  Print help
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
-w, --ignore-all-space      Ignore whitespace when comparing lines
-b, --ignore-space-change   Ignore changes in amount of whitespace
```
