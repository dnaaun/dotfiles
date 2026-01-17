---
description: "jj diffedit - Touch up the content changes in a revision with a diff editor"
---

# jj diffedit

Touch up the content changes in a revision with a diff editor.

With the `-r` option, starts a diff editor on the changes in the revision.

With the `--from` and/or `--to` options, starts a diff editor comparing the "from" revision to the "to" revision.

Edit the right side of the diff until it looks the way you want. Once you close the editor, the revision specified with `-r` or `--to` will be updated. Unless `--restore-descendants` is used, descendants will be rebased on top as usual, which may result in conflicts.

See `jj restore` if you want to move entire files from one revision to another. For moving changes between revisions, see `jj squash -i`.

## Usage

```
jj diffedit [OPTIONS] [FILESETS]...
```

## Arguments

- `[FILESETS]...` - Edit only these paths (unmatched paths will remain unchanged)

## Options

```
-r, --revision <REVSET>     The revision to touch up
                            Defaults to @ if neither --to nor --from are specified.

-f, --from <REVSET>         Show changes from this revision
                            Defaults to @ if --to is specified.

-t, --to <REVSET>           Edit changes in this revision
                            Defaults to @ if --from is specified.

--tool <NAME>               Specify diff editor to be used

--restore-descendants       Preserve the content (not the diff) when rebasing descendants

-h, --help                  Print help
```
