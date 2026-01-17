---
description: "jj new - Create a new, empty change and (by default) edit it in the working copy"
---

# jj new

Create a new, empty change and (by default) edit it in the working copy.

By default, `jj` will edit the new change, making the working copy represent the new commit. This can be avoided with `--no-edit`.

Note: you can create a merge commit by specifying multiple revisions as argument. For example, `jj new @ main` will create a new commit with the working copy and the `main` bookmark as parents.

## Usage

```
jj new [OPTIONS] [REVSETS]...
```

## Arguments

- `[REVSETS]...` - Parent(s) of the new change [default: @]

## Options

```
-m, --message <MESSAGE>        The change description to use

--no-edit                      Do not edit the newly created change

-A, --insert-after <REVSETS>   Insert the new change after the given commit(s)
                               [aliases: --after]

-B, --insert-before <REVSETS>  Insert the new change before the given commit(s)
                               [aliases: --before]

-h, --help                     Print help
```

## Examples

Create a new empty commit on top of the current working copy:
```bash
jj new
```

Create a merge commit:
```bash
jj new @ main
```

Insert a commit between A and its children:
```bash
jj new --after A
```

Insert a commit between C and its parents:
```bash
jj new --before C
```
