---
description: "jj file show - Print contents of files in a revision"
---

# jj file show

Print contents of files in a revision.

If the given path is a directory, files in the directory will be visited recursively.

## Usage

```
jj file show [OPTIONS] <FILESETS>...
```

## Arguments

- `<FILESETS>...` - Paths to print

## Options

```
-r, --revision <REVSET>     The revision to get the file contents from [default: @]

-T, --template <TEMPLATE>   Render each file metadata using the given template

-h, --help                  Print help
```
