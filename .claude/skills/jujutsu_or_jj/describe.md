---
description: "jj describe - Update the change description or other metadata [alias: desc]"
---

# jj describe

Update the change description or other metadata.

Starts an editor to let you edit the description of changes. The editor will be $EDITOR, or `nano` if that's not defined (`Notepad` on Windows).

## Usage

```
jj describe [OPTIONS] [REVSETS]...
```

## Arguments

- `[REVSETS]...` - The revision(s) whose description to edit (default: @)

## Options

```
-m, --message <MESSAGE>   The change description to use (don't open editor)
                          If multiple revisions are specified, the same description
                          will be used for all of them.

--stdin                   Read the change description from stdin

--edit                    Open an editor
                          Forces an editor to open when using --stdin or --message

-h, --help                Print help
```
