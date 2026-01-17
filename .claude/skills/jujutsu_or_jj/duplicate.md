---
description: "jj duplicate - Create new changes with the same content as existing ones"
---

# jj duplicate

Create new changes with the same content as existing ones.

When none of the `--destination`, `--insert-after`, or `--insert-before` arguments are provided, commits will be duplicated onto their existing parents or onto other newly duplicated commits.

When any of the `--destination`, `--insert-after`, or `--insert-before` arguments are provided, the roots of the specified commits will be duplicated onto the destination indicated by the arguments.

## Usage

```
jj duplicate [OPTIONS] [REVSETS]...
```

## Arguments

- `[REVSETS]...` - The revision(s) to duplicate (default: @)

## Options

```
-d, --destination <REVSETS>    The revision(s) to duplicate onto
                               (can be repeated to create a merge commit)

-A, --insert-after <REVSETS>   The revision(s) to insert after [aliases: --after]

-B, --insert-before <REVSETS>  The revision(s) to insert before [aliases: --before]

-h, --help                     Print help
```
