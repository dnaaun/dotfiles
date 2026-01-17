---
description: "jj log - Show revision history"
---

# jj log

Show revision history.

Renders a graphical view of the project's history, ordered with children before parents. By default, the output only includes mutable revisions, along with some additional revisions for context. Use `jj log -r ::` to see all revisions.

See `jj help -k revsets` for information about the syntax: https://jj-vcs.github.io/jj/latest/revsets/

The working-copy commit is indicated by a `@` symbol in the graph. Immutable revisions have a `◆` symbol. Other commits have a `○` symbol.

## Usage

```
jj log [OPTIONS] [FILESETS]...
```

## Arguments

- `[FILESETS]...` - Show revisions modifying the given paths

## Options

```
-r, --revisions <REVSETS>   Which revisions to show
                            If no paths nor revisions are specified, defaults to
                            the revsets.log setting.

-n, --limit <LIMIT>         Limit number of revisions to show

--reversed                  Show revisions in the opposite order (older revisions first)

--no-graph                  Don't show the graph, show a flat list of revisions

-T, --template <TEMPLATE>   Render each revision using the given template
                            Run jj log -T to list the built-in templates.

-p, --patch                 Show patch

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
