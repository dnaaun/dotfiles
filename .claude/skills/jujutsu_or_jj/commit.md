---
description: "jj commit - Update the description and create a new change on top [alias: ci]"
---

# jj commit

Update the description and create a new change on top.

When called without path arguments or `--interactive`, `jj commit` is equivalent to `jj describe` followed by `jj new`.

Otherwise, this command is very similar to `jj split`. Differences include:
- `jj commit` is not interactive by default (it selects all changes).
- `jj commit` doesn't have a `-r` option. It always acts on the working-copy commit (@).
- `jj split` (without `-d/-A/-B`) will move bookmarks forward from the old change to the child change. `jj commit` doesn't move bookmarks forward.
- `jj split` allows you to move the selected changes to a different destination with `-d/-A/-B`.

## Usage

```
jj commit [OPTIONS] [FILESETS]...
```

## Arguments

- `[FILESETS]...` - Put these paths in the first commit

## Options

```
-i, --interactive     Interactively choose which changes to include in the first commit

--tool <NAME>         Specify diff editor to be used (implies --interactive)

-m, --message <MSG>   The change description to use (don't open editor)

-h, --help            Print help
```
