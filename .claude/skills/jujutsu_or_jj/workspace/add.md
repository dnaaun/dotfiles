---
description: "jj workspace add - Add a workspace"
---

# jj workspace add

Add a workspace.

By default, the new workspace inherits the sparse patterns of the current workspace. You can override this with the `--sparse-patterns` option.

## Usage

```
jj workspace add [OPTIONS] <DESTINATION>
```

## Arguments

- `<DESTINATION>` - Where to create the new workspace

## Options

```
--name <NAME>                       A name for the workspace
                                    Defaults to the basename of the destination directory.

-r, --revision <REVSETS>            Parent revision(s) for the working-copy commit

--sparse-patterns <SPARSE_PATTERNS> How to handle sparse patterns when creating a new workspace
                                    [possible values: copy, full, empty]
                                    [default: copy]

-h, --help                          Print help
```
