---
description: "jj evolog - Show how a change has evolved over time [alias: evolution-log]"
---

# jj evolog

Show how a change has evolved over time.

Lists the previous commits which a change has pointed to. The current commit of a change evolves when the change is updated, rebased, etc.

## Usage

```
jj evolog [OPTIONS]
```

## Options

```
-r, --revisions <REVSETS>   Follow changes from these revisions [default: @]

-n, --limit <LIMIT>         Limit number of revisions to show

--reversed                  Show revisions in the opposite order (older revisions first)

--no-graph                  Don't show the graph, show a flat list of revisions

-T, --template <TEMPLATE>   Render each revision using the given template

-p, --patch                 Show patch compared to the previous version of this change

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
--ignore-all-space          Ignore whitespace when comparing lines
--ignore-space-change       Ignore changes in amount of whitespace
```
