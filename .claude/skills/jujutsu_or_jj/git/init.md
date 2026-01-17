---
description: "jj git init - Create a new Git backed repo"
---

# jj git init

Create a new Git backed repo.

## Usage

```
jj git init [OPTIONS] [DESTINATION]
```

## Arguments

- `[DESTINATION]` - The destination directory. Defaults to current directory.

## Options

```
--colocate               Make the jj repo also be a valid git repo
                         This places the backing git repo into a .git directory
                         in the root of the jj repo along with the .jj directory.

--no-colocate            Disable colocation

--git-repo <GIT_REPO>    Path to an existing git repository to use as the backing repo
                         Mutually exclusive with --colocate.

-h, --help               Print help
```
