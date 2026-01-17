---
description: "jj sparse set - Update the patterns that are present"
---

# jj sparse set

Update the patterns that are present in the working copy.

## Usage

```
jj sparse set [OPTIONS]
```

## Options

```
--add <ADD>         Patterns to add to the working copy

--remove <REMOVE>   Patterns to remove from the working copy

--clear             Include no files in the working copy (combine with --add)

-h, --help          Print help
```

## Example

If all you need is the `README.md` and the `lib/` directory:
```bash
jj sparse set --clear --add README.md --add lib
```

To remove the `lib` directory:
```bash
jj sparse set --remove lib
```
