---
description: "jj restore - Restore paths from another revision"
---

# jj restore

Restore paths from another revision.

That means that the paths get the same content in the destination (`--to`) as they had in the source (`--from`). This is typically used for undoing changes to some paths in the working copy (`jj restore <paths>`).

If only one of `--from` or `--to` is specified, the other one defaults to the working copy.

When neither `--from` nor `--to` is specified, the command restores into the working copy from its parent(s). `jj restore` without arguments is similar to `jj abandon`, except that it leaves an empty revision with its description and other metadata preserved.

See `jj diffedit` if you'd like to restore portions of files rather than entire files.

## Usage

```
jj restore [OPTIONS] [FILESETS]...
```

## Arguments

- `[FILESETS]...` - Restore only these paths (instead of all paths)

## Options

```
-f, --from <REVSET>         Revision to restore from (source)

-t, --into <REVSET>         Revision to restore into (destination) [aliases: --to]

-c, --changes-in <REVSET>   Undo the changes in a revision as compared to the merge of its parents

-i, --interactive           Interactively choose which parts to restore

--tool <NAME>               Specify diff editor to be used (implies --interactive)

--restore-descendants       Preserve the content (not the diff) when rebasing descendants

-h, --help                  Print help
```
