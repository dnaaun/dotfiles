---
description: "jj revert - Apply the reverse of the given revision(s)"
---

# jj revert

Apply the reverse of the given revision(s).

The reverse of each of the given revisions is applied sequentially in reverse topological order at the given location.

The description of the new revisions can be customized with the `templates.revert_description` config variable.

## Usage

```
jj revert [OPTIONS] <--destination <REVSETS>|--insert-after <REVSETS>|--insert-before <REVSETS>>
```

## Options

```
-r, --revisions <REVSETS>      The revision(s) to apply the reverse of

-d, --destination <REVSETS>    The revision(s) to apply the reverse changes on top of

-A, --insert-after <REVSETS>   The revision(s) to insert the reverse changes after
                               [aliases: --after]

-B, --insert-before <REVSETS>  The revision(s) to insert the reverse changes before
                               [aliases: --before]

-h, --help                     Print help
```
