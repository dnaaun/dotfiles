---
name: jj
description: "Jujutsu (jj) version control system command reference. Use this skill when the user asks about jj commands, options, workflows, or needs help with Jujutsu VCS operations. Provides documentation for all jj subcommands including git, bookmark, config, file, operation, workspace, and more."
---

# jj - Jujutsu Version Control System

Jujutsu is an experimental VCS. To get started, see the tutorial: `jj help -k tutorial`
https://jj-vcs.github.io/jj/latest/tutorial/

## Usage

```
jj [OPTIONS] <COMMAND>
```

## Commands

For detailed help on any command, read the linked reference file.

### Core Operations
- [jj abandon](abandon.md) - Abandon a revision
- [jj absorb](absorb.md) - Move changes from a revision into the stack of mutable revisions
- [jj commit](commit.md) (alias: ci) - Update the description and create a new change on top
- [jj describe](describe.md) (alias: desc) - Update the change description or other metadata
- [jj diff](diff.md) - Compare file contents between two revisions
- [jj diffedit](diffedit.md) - Touch up the content changes in a revision with a diff editor
- [jj duplicate](duplicate.md) - Create new changes with the same content as existing ones
- [jj edit](edit.md) - Sets the specified revision as the working-copy revision
- [jj new](new.md) - Create a new, empty change and (by default) edit it in the working copy
- [jj restore](restore.md) - Restore paths from another revision
- [jj revert](revert.md) - Apply the reverse of the given revision(s)
- [jj split](split.md) - Split a revision in two
- [jj squash](squash.md) - Move changes from a revision into another revision

### Navigation
- [jj log](log.md) - Show revision history
- [jj show](show.md) - Show commit description and changes in a revision
- [jj status](status.md) (alias: st) - Show high-level repo status
- [jj next](next.md) - Move the working-copy commit to the child revision
- [jj prev](prev.md) - Change the working copy revision relative to the parent revision
- [jj evolog](evolog.md) (alias: evolution-log) - Show how a change has evolved over time
- [jj interdiff](interdiff.md) - Compare the changes of two commits

### History Manipulation
- [jj rebase](rebase.md) - Move revisions to different parent(s)
- [jj parallelize](parallelize.md) - Parallelize revisions by making them siblings
- [jj simplify-parents](simplify-parents.md) - Simplify parent edges for the specified revision(s)
- [jj metaedit](metaedit.md) - Modify the metadata of a revision without changing its content

### Undo/Redo
- [jj undo](undo.md) - Undo the last operation
- [jj redo](redo.md) - Redo the most recently undone operation

### Conflict Resolution
- [jj resolve](resolve.md) - Resolve conflicted files with an external merge tool

### Code Formatting
- [jj fix](fix.md) - Update files with formatting fixes or other changes

### Debugging/Bisection
- [jj bisect](bisect.md) - Find a bad revision by bisection (subcommands: [run](bisect/run.md))

### Signing
- [jj sign](sign.md) - Cryptographically sign a revision
- [jj unsign](unsign.md) - Drop a cryptographic signature

### Command Groups (with subcommands)
- [jj bookmark](bookmark.md) (alias: b) - Manage bookmarks
  - [create](bookmark/create.md), [delete](bookmark/delete.md), [forget](bookmark/forget.md), [list](bookmark/list.md), [move](bookmark/move.md), [rename](bookmark/rename.md), [set](bookmark/set.md), [track](bookmark/track.md), [untrack](bookmark/untrack.md)
- [jj config](config.md) - Manage config options
  - [edit](config/edit.md), [get](config/get.md), [list](config/list.md), [path](config/path.md), [set](config/set.md), [unset](config/unset.md)
- [jj file](file.md) - File operations
  - [annotate](file/annotate.md), [chmod](file/chmod.md), [list](file/list.md), [show](file/show.md), [track](file/track.md), [untrack](file/untrack.md)
- [jj gerrit](gerrit.md) - Interact with Gerrit Code Review
  - [upload](gerrit/upload.md)
- [jj git](git.md) - Commands for working with Git remotes and the underlying Git repo
  - [clone](git/clone.md), [export](git/export.md), [fetch](git/fetch.md), [import](git/import.md), [init](git/init.md), [push](git/push.md), [remote](git/remote.md), [root](git/root.md)
  - `jj git remote` subcommands: [add](git/remote/add.md), [list](git/remote/list.md), [remove](git/remote/remove.md), [rename](git/remote/rename.md), [set-url](git/remote/set-url.md)
- [jj operation](operation.md) (alias: op) - Commands for working with the operation log
  - [abandon](operation/abandon.md), [diff](operation/diff.md), [log](operation/log.md), [restore](operation/restore.md), [revert](operation/revert.md), [show](operation/show.md)
- [jj sparse](sparse.md) - Manage which paths from the working-copy commit are present
  - [edit](sparse/edit.md), [list](sparse/list.md), [reset](sparse/reset.md), [set](sparse/set.md)
- [jj tag](tag.md) - Manage tags
  - [list](tag/list.md)
- [jj util](util.md) - Infrequently used commands such as for generating shell completions
  - [completion](util/completion.md), [config-schema](util/config-schema.md), [exec](util/exec.md), [gc](util/gc.md), [install-man-pages](util/install-man-pages.md), [markdown-help](util/markdown-help.md)
- [jj workspace](workspace.md) - Commands for working with workspaces
  - [add](workspace/add.md), [forget](workspace/forget.md), [list](workspace/list.md), [rename](workspace/rename.md), [root](workspace/root.md), [update-stale](workspace/update-stale.md)

### Other
- [jj help](help.md) - Print this message or the help of the given subcommand(s)
- [jj root](root.md) - Show the current workspace root directory
- [jj version](version.md) - Display version information

## Global Options

```
-R, --repository <REPOSITORY>   Path to repository to operate on
--ignore-working-copy           Don't snapshot the working copy, and don't update it
--ignore-immutable              Allow rewriting immutable commits
--at-operation <AT_OPERATION>   Operation to load the repo at [aliases: --at-op]
--debug                         Enable debug logging
--color <WHEN>                  When to colorize output [always, never, debug, auto]
--quiet                         Silence non-primary command output
--no-pager                      Disable the pager
--config <NAME=VALUE>           Additional configuration options (can be repeated)
--config-file <PATH>            Additional configuration files (can be repeated)
-h, --help                      Print help
-V, --version                   Print version
```

## Help Keywords

Use `jj help -k <keyword>` to show help for specific topics:
- `bookmarks` - Named pointers to revisions (similar to Git's branches)
- `config` - How and where to set configuration options
- `filesets` - A functional language for selecting a set of files
- `glossary` - Definitions of various terms
- `revsets` - A functional language for selecting a set of revisions
- `templates` - A functional language to customize command output
- `tutorial` - Show a tutorial to get started with jj
