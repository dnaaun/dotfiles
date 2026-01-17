---
description: "jj next - Move the working-copy commit to the child revision"
---

# jj next

Move the working-copy commit to the child revision.

The command creates a new empty working copy revision that is the child of a descendant `offset` revisions ahead of the parent of the current working copy.

## Usage

```
jj next [OPTIONS] [OFFSET]
```

## Arguments

- `[OFFSET]` - How many revisions to move forward (default: 1)

## Options

```
-e, --edit       Instead of creating a new working-copy commit on top of the
                 target commit (like jj new), edit the target commit directly
                 (like jj edit)

-n, --no-edit    The inverse of --edit

--conflict       Jump to the next conflicted descendant

-h, --help       Print help
```

## Example

```
D        D @
|        |/
C @  =>  C
|/       |
B        B
```

With `--edit`:
```
D        D
|        |
C        C
|        |
B   =>   @
|        |
@        A
```
