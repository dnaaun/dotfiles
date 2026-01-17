---
description: "jj workspace forget - Stop tracking a workspace's working-copy commit in the repo"
---

# jj workspace forget

Stop tracking a workspace's working-copy commit in the repo.

The workspace will not be touched on disk. It can be deleted from disk before or after running this command.

## Usage

```
jj workspace forget [OPTIONS] [WORKSPACES]...
```

## Arguments

- `[WORKSPACES]...` - Names of the workspaces to forget. By default, forgets only the current workspace.

## Options

```
-h, --help    Print help
```
