---
description: "jj squash - Move changes from a revision into another revision"
---

# jj squash

Move changes from a revision into another revision.

With the `-r` option, moves the changes from the specified revision to the parent revision. Fails if there are several parent revisions (i.e., the given revision is a merge).

With the `--from` and/or `--into` options, moves changes from/to the given revisions. If either is left out, it defaults to the working-copy commit. For example, `jj squash --into @--` moves changes from the working-copy commit to the grandparent.

If, after moving changes out, the source revision is empty compared to its parent(s), and `--keep-emptied` is not set, it will be abandoned. Without `--interactive` or paths, the source revision will always be empty.

## Usage

```
jj squash [OPTIONS] [FILESETS]...
```

## Arguments

- `[FILESETS]...` - Move only changes to these paths (instead of all paths)

## Options

```
-r, --revision <REVSET>        Revision to squash into its parent (default: @)

-f, --from <REVSETS>           Revision(s) to squash from (default: @)

-t, --into <REVSET>            Revision to squash into (default: @) [aliases: --to]

-d, --destination <REVSETS>    (Experimental) The revision(s) to use as parent for the new commit

-A, --insert-after <REVSETS>   (Experimental) The revision(s) to insert the new commit after
                               [aliases: --after]

-B, --insert-before <REVSETS>  (Experimental) The revision(s) to insert the new commit before
                               [aliases: --before]

-m, --message <MESSAGE>        The description to use for squashed revision

-u, --use-destination-message  Use the description of the destination revision

-i, --interactive              Interactively choose which parts to squash

--tool <NAME>                  Specify diff editor to be used (implies --interactive)

-k, --keep-emptied             The source revision will not be abandoned

-h, --help                     Print help
```
