---
description: "jj workspace - Commands for working with workspaces"
---

# jj workspace

Commands for working with workspaces.

Workspaces let you add additional working copies attached to the same repo. A common use case is so you can run a slow build or test in one workspace while you're continuing to write code in another workspace.

Each workspace has its own working-copy commit. When you have more than one workspace attached to a repo, they are indicated by `<workspace name>@` in `jj log`.

Each workspace also has its own sparse patterns.

## Usage

```
jj workspace [OPTIONS] <COMMAND>
```

## Commands

- [add](./workspace/add.md) - Add a workspace
- [forget](./workspace/forget.md) - Stop tracking a workspace's working-copy commit in the repo
- [list](./workspace/list.md) - List workspaces
- [rename](./workspace/rename.md) - Renames the current workspace
- [root](./workspace/root.md) - Show the current workspace root directory
- [update-stale](./workspace/update-stale.md) - Update a workspace that has become stale

## Options

```
-h, --help    Print help
```
