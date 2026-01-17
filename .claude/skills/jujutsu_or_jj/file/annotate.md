---
description: "jj file annotate - Show the source change for each line of the target file"
---

# jj file annotate

Show the source change for each line of the target file.

Annotates a revision line by line. Each line includes the source change that introduced the associated line. A path to the desired file must be provided.

## Usage

```
jj file annotate [OPTIONS] <PATH>
```

## Arguments

- `<PATH>` - The file to annotate

## Options

```
-r, --revision <REVSET>     An optional revision to start at

-T, --template <TEMPLATE>   Render each line using the given template

-h, --help                  Print help
```
