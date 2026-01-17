---
description: "jj help - Print help message or help for subcommands"
---

# jj help

Print this message or the help of the given subcommand(s).

## Usage

```
jj help [OPTIONS] [COMMAND]...
```

## Arguments

- `[COMMAND]...` - Print help for the subcommand(s)

## Options

```
-k, --keyword <KEYWORD>   Show help for keywords instead of commands

-h, --help                Print help
```

## Keywords

Use `jj help -k <keyword>` for help on these topics:

- `bookmarks` - Named pointers to revisions (similar to Git's branches)
- `config` - How and where to set configuration options
- `filesets` - A functional language for selecting a set of files
- `glossary` - Definitions of various terms
- `revsets` - A functional language for selecting a set of revisions
- `templates` - A functional language to customize command output
- `tutorial` - Show a tutorial to get started with jj
