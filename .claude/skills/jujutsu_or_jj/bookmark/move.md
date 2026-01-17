---
description: "jj bookmark move - Move existing bookmarks to target revision [alias: m]"
---

# jj bookmark move

Move existing bookmarks to target revision.

## Usage

```
jj bookmark move [OPTIONS] [NAMES]...
```

## Arguments

- `[NAMES]...` - Move bookmarks matching the given patterns. Defaults to all bookmarks.

## Options

```
-f, --from <REVSETS>      Move bookmarks from the given revisions

-t, --to <REVSET>         Move bookmarks to this revision [default: @]

-B, --allow-backwards     Allow moving bookmarks backwards or sideways

-h, --help                Print help
```
