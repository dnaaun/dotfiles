---
description: "jj util gc - Run backend-dependent garbage collection"
---

# jj util gc

Run backend-dependent garbage collection.

To garbage-collect old operations and the commits/objects referenced by them, run `jj op abandon ..<some old operation>` before `jj util gc`.

## Usage

```
jj util gc [OPTIONS]
```

## Options

```
--expire <EXPIRE>   Time threshold
                    By default, only obsolete objects and operations older than
                    2 weeks are pruned.
                    Only the string "now" can be passed to this parameter.

-h, --help          Print help
```
