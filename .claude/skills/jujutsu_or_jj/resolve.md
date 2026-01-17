---
description: "jj resolve - Resolve conflicted files with an external merge tool"
---

# jj resolve

Resolve conflicted files with an external merge tool.

Only conflicts that can be resolved with a 3-way merge are supported. See docs for merge tool configuration instructions. External merge tools will be invoked for each conflicted file one-by-one until all conflicts are resolved. To stop resolving conflicts, exit the merge tool without making any changes.

Note that conflicts can also be resolved without using this command. You may edit the conflict markers in the conflicted file directly with a text editor.

## Usage

```
jj resolve [OPTIONS] [FILESETS]...
```

## Arguments

- `[FILESETS]...` - Only resolve conflicts in these paths. Use `--list` to find paths.

## Options

```
-r, --revision <REVSET>   [default: @]

-l, --list                Instead of resolving conflicts, list all the conflicts

--tool <NAME>             Specify 3-way merge tool to be used
                          The built-in merge tools :ours and :theirs can be used
                          to choose side #1 and side #2 of the conflict respectively.

-h, --help                Print help
```
