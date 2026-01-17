---
description: "jj absorb - Move changes from a revision into the stack of mutable revisions"
---

# jj absorb

Move changes from a revision into the stack of mutable revisions.

This command splits changes in the source revision and moves each change to the closest mutable ancestor where the corresponding lines were modified last. If the destination revision cannot be determined unambiguously, the change will be left in the source revision.

The source revision will be abandoned if all changes are absorbed into the destination revisions, and if the source revision has no description.

The modification made by `jj absorb` can be reviewed by `jj op show -p`.

## Usage

```
jj absorb [OPTIONS] [FILESETS]...
```

## Arguments

- `[FILESETS]...` - Move only changes to these paths (instead of all paths)

## Options

```
-f, --from <REVSET>    Source revision to absorb from [default: @]

-t, --into <REVSETS>   Destination revisions to absorb into
                       Only ancestors of the source revision will be considered.
                       [default: mutable()] [aliases: --to]

-h, --help             Print help
```
