---
description: "jj sign - Cryptographically sign a revision"
---

# jj sign

Cryptographically sign a revision.

This command requires configuring a commit signing backend. See: https://jj-vcs.github.io/jj/latest/config/#commit-signing

## Usage

```
jj sign [OPTIONS]
```

## Options

```
-r, --revisions <REVSETS>   What revision(s) to sign
                            If no revisions are specified, defaults to the revsets.sign setting.

--key <KEY>                 The key used for signing

-h, --help                  Print help
```
