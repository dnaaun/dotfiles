---
description: "jj simplify-parents - Simplify parent edges for the specified revision(s)"
---

# jj simplify-parents

Simplify parent edges for the specified revision(s).

Removes all parents of each of the specified revisions that are also indirect ancestors of the same revisions through other parents. This has no effect on any revision's contents, including the working copy.

In other words, for all (A, B, C) where A has (B, C) as parents and C is an ancestor of B, A will be rewritten to have only B as a parent instead of B+C.

## Usage

```
jj simplify-parents [OPTIONS]
```

## Options

```
-s, --source <REVSETS>      Simplify specified revision(s) together with their trees of descendants

-r, --revisions <REVSETS>   Simplify specified revision(s)
                            If both --source and --revisions are not provided, defaults to
                            the revsets.simplify-parents setting, or reachable(@, mutable())

-h, --help                  Print help
```
