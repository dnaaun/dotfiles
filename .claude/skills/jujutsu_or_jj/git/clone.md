---
description: "jj git clone - Create a new repo backed by a clone of a Git repo"
---

# jj git clone

Create a new repo backed by a clone of a Git repo.

The Git repo will be a bare git repo stored inside the `.jj/` directory.

## Usage

```
jj git clone [OPTIONS] <SOURCE> [DESTINATION]
```

## Arguments

- `<SOURCE>` - URL or path of the Git repo to clone. Local path will be resolved to absolute form.
- `[DESTINATION]` - The target directory. Defaults to a directory named after the last component of the source URL.

## Options

```
--remote <REMOTE_NAME>   Name of the newly created remote [default: origin]

--colocate               Whether or not to colocate the Jujutsu repo with the git repo

--no-colocate            Disable colocation

--depth <DEPTH>          Create a shallow clone of the given depth

--fetch-tags <FETCH_TAGS>   Configure when to fetch tags
                            [possible values: all, included, none]

-h, --help               Print help
```
