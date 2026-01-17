---
description: "jj git fetch - Fetch from a Git remote"
---

# jj git fetch

Fetch from a Git remote.

If a working-copy commit gets abandoned, it will be given a new, empty commit.

## Usage

```
jj git fetch [OPTIONS]
```

## Options

```
-b, --branch <BRANCH>   Fetch only some of the branches
                        By default, matches exactly. Use `glob:` prefix for wildcards.

--tracked               Fetch only tracked bookmarks

--remote <REMOTE>       The remote to fetch from (can be repeated)
                        Defaults to the git.fetch setting. If not configured,
                        defaults to "origin".

--all-remotes           Fetch from all remotes

-h, --help              Print help
```
