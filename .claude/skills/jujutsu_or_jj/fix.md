---
description: "jj fix - Update files with formatting fixes or other changes"
---

# jj fix

Update files with formatting fixes or other changes.

The primary use case for this command is to apply the results of automatic code formatting tools to revisions that may not be properly formatted yet. It can also be used to modify files with other tools like `sed` or `sort`.

The changed files in the given revisions will be updated with any fixes determined by passing their file content through any external tools the user has configured for those files. Descendants will also be updated by passing their versions of the same files through the same tools.

## Usage

```
jj fix [OPTIONS] [FILESETS]...
```

## Arguments

- `[FILESETS]...` - Fix only these paths

## Options

```
-s, --source <REVSETS>          Fix files in the specified revision(s) and their descendants
                                If no revisions are specified, defaults to the revsets.fix
                                setting, or reachable(@, mutable()) if not set

--include-unchanged-files       Fix unchanged files in addition to changed ones

-h, --help                      Print help
```

## Configuration Example

```toml
[fix.tools.clang-format]
command = ["/usr/bin/clang-format", "--assume-filename=$path"]
patterns = ["glob:'**/*.cc'", "glob:'**/*.h'"]

[fix.tools.black]
command = ["/usr/bin/black", "-", "--stdin-filename=$path"]
patterns = ["glob:'**/*.py'"]
```
