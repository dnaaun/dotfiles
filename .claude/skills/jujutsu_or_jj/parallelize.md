---
description: "jj parallelize - Parallelize revisions by making them siblings"
---

# jj parallelize

Parallelize revisions by making them siblings.

Running `jj parallelize 1::2` will transform the history like this:
```
3
|             3
2            / \
|    ->     1   2
1            \ /
|             0
0
```

The command effectively says "these revisions are actually independent", meaning that they should no longer be ancestors/descendants of each other. However, revisions outside the set that were previously ancestors of a revision in the set will remain ancestors of it.

## Usage

```
jj parallelize [OPTIONS] [REVSETS]...
```

## Arguments

- `[REVSETS]...` - Revisions to parallelize

## Options

```
-h, --help    Print help
```
