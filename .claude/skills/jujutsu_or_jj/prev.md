---
description: "jj prev - Change the working copy revision relative to the parent revision"
---

# jj prev

Change the working copy revision relative to the parent revision.

The command creates a new empty working copy revision that is the child of an ancestor `offset` revisions behind the parent of the current working copy.

## Usage

```
jj prev [OPTIONS] [OFFSET]
```

## Arguments

- `[OFFSET]` - How many revisions to move backward (default: 1)

## Options

```
-e, --edit     Edit the parent directly, instead of moving the working-copy commit

-n, --no-edit  The inverse of --edit

--conflict     Jump to the previous conflicted ancestor

-h, --help     Print help
```

## Example

```
D @      D
|/       |
A   =>   A @
|        |/
B        B
```

With `--edit`:
```
D @      D
|/       |
C   =>   @
|        |
B        B
|        |
A        A
```
