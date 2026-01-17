---
description: "jj file track - Start tracking specified paths in the working copy"
---

# jj file track

Start tracking specified paths in the working copy.

Without arguments, all paths that are not ignored will be tracked.

By default, new files in the working copy are automatically tracked, so this command has no effect. You can configure which paths to automatically track by setting `snapshot.auto-track` (e.g. to `"none()"` or `"glob:**/*.rs"`).

## Usage

```
jj file track [OPTIONS] <FILESETS>...
```

## Arguments

- `<FILESETS>...` - Paths to track

## Options

```
-h, --help    Print help
```
