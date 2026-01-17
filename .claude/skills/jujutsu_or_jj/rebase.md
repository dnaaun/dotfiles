---
description: "jj rebase - Move revisions to different parent(s)"
---

# jj rebase

Move revisions to different parent(s).

This command moves revisions to different parent(s) while preserving the changes (diff) in the revisions.

## Specifying Which Revisions to Rebase

- `--source/-s` - Rebase a revision and its descendants
- `--branch/-b` - Rebase a whole branch, relative to the destination
- `--revisions/-r` - Rebase the specified revisions without their descendants

If no option is specified, it defaults to `-b @`.

## Specifying Where to Rebase

- `--destination/-d` - Rebase onto the specified targets
- `--insert-after/-A` - Insert after targets, rebasing targets' descendants onto rebased revisions
- `--insert-before/-B` - Insert before targets, rebasing targets onto rebased revisions

## Usage

```
jj rebase [OPTIONS] <--destination <REVSETS>|--insert-after <REVSETS>|--insert-before <REVSETS>>
```

## Options

```
-b, --branch <REVSETS>         Rebase the whole branch relative to destination's ancestors

-s, --source <REVSETS>         Rebase specified revision(s) together with their trees of descendants

-r, --revisions <REVSETS>      Rebase the given revisions, rebasing descendants onto the revision's parent(s)

-d, --destination <REVSETS>    The revision(s) to rebase onto

-A, --insert-after <REVSETS>   The revision(s) to insert after [aliases: --after]

-B, --insert-before <REVSETS>  The revision(s) to insert before [aliases: --before]

--skip-emptied                 If true, when rebasing would produce an empty commit, abandon it

--keep-divergent               Keep divergent commits while rebasing

-h, --help                     Print help
```

## Examples

Rebase current branch onto main:
```bash
jj rebase -d main
```

Rebase specific revision and descendants:
```bash
jj rebase -s M -d O
```

Create a merge commit:
```bash
jj rebase -s L -d K -d M
```
