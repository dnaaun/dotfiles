---
description: "jj bookmark list - List bookmarks and their targets [alias: l]"
---

# jj bookmark list

List bookmarks and their targets.

## Usage

```
jj bookmark list [OPTIONS] [NAMES]...
```

## Arguments

- `[NAMES]...` - Show bookmarks whose local name matches (glob patterns allowed)

## Options

```
-a, --all                    Show all tracking and non-tracking remote bookmarks including deleted

-d, --deleted                Show only deleted bookmarks

-c, --conflicted             Show only conflicted bookmarks

-t, --tracked                Show only tracked bookmarks

-r, --revisions <REVSETS>    Show bookmarks whose targets are in the given revisions

-T, --template <TEMPLATE>    Render each bookmark using the given template

-h, --help                   Print help
```
