---
description: "jj file chmod - Sets or removes the executable bit for paths"
---

# jj file chmod

Sets or removes the executable bit for paths in the repo.

Unlike the POSIX `chmod`, `jj file chmod` also works on Windows, on conflicted files, and on arbitrary revisions.

## Usage

```
jj file chmod [OPTIONS] <MODE> <FILESETS>...
```

## Arguments

- `<MODE>` - `n` (normal/non-executable) or `x` (executable)
- `<FILESETS>...` - Paths to change the executable bit for

## Options

```
-r, --revision <REVSET>   The revision to update [default: @]

-h, --help                Print help
```
