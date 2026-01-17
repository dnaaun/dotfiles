---
description: "jj bookmark set - Create or update a bookmark to point to a certain commit [alias: s]"
---

# jj bookmark set

Create or update a bookmark to point to a certain commit.

## Usage

```
jj bookmark set [OPTIONS] <NAMES>...
```

## Arguments

- `<NAMES>...` - The bookmarks to update

## Options

```
-r, --revision <REVSET>   The bookmark's target revision [default: @]

-B, --allow-backwards     Allow moving the bookmark backwards or sideways

-h, --help                Print help
```
