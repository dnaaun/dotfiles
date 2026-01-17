---
description: "jj split - Split a revision in two"
---

# jj split

Split a revision in two.

Starts a diff editor on the changes in the revision. Edit the right side of the diff until it has the content you want in the new revision. Once you close the editor, your edited content will replace the previous revision. The remaining changes will be put in a new revision on top.

If the change you split had a description, you will be asked to enter a change description for each commit. If the change did not have a description, the remaining changes will not get a description, and you will be asked for a description only for the selected changes.

Splitting an empty commit is not supported because the same effect can be achieved with `jj new`.

## Usage

```
jj split [OPTIONS] [FILESETS]...
```

## Arguments

- `[FILESETS]...` - Files matching any of these filesets are put in the selected changes

## Options

```
-i, --interactive              Interactively choose which parts to split
                               This is the default if no filesets are provided.

--tool <NAME>                  Specify diff editor to be used (implies --interactive)

-r, --revision <REVSET>        The revision to split [default: @]

-d, --destination <REVSETS>    The revision(s) to base the new revision onto

-A, --insert-after <REVSETS>   The revision(s) to insert after [aliases: --after]

-B, --insert-before <REVSETS>  The revision(s) to insert before [aliases: --before]

-m, --message <MESSAGE>        The change description to use (don't open editor)

-p, --parallel                 Split the revision into two parallel revisions instead
                               of a parent and child

-h, --help                     Print help
```
