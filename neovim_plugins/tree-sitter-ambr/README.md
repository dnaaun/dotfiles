# tree-sitter-ambr

A [tree-sitter](https://tree-sitter.github.io/) grammar for `.ambr` files, the
"amber" snapshot format written by [syrupy](https://github.com/syrupy-project/syrupy).

```
# serializer version: 1
# name: test_something[param]
  dict({
    'key': list([
      1,
    ]),
    'text': '''
      multi
      line
    ''',
  })
# ---
```

## Node types

| Node                                        | Source                                                    |
| ------------------------------------------- | --------------------------------------------------------- |
| `version_marker`, `name_marker`, `divider`  | the `# serializer version:`, `# name:` and `# ---` lines  |
| `snapshot`                                  | one `# name:` ... `# ---` block, `value:` field           |
| `dict`, `set`, `list`, `tuple`, `object`    | `Name({`, `Name({` (no `:`), `Name([`, `Name(`, `Name(` with `x=1,` entries |
| `pair`, `attribute`                         | `key: value,` and `name=value,` entries                   |
| `string`, `number`, `boolean`, `none`       | single-line Python literals                               |
| `ellipsis`                                  | syrupy's `…` for cycles and over-deep values              |
| `multiline_string`                          | `'''` blocks, body in `multiline_string_content`          |
| `plain`                                     | any other single-line `repr()`, e.g. `<Foo object at 0x1>` |

Single-line values are lexed by the external scanner in `src/scanner.c`
because a `repr()` can contain anything, including the `,` and `: ` that
also delimit entries. It stops before a trailing `,`, and before `: ` when
the value so far is a Python literal. A dict key whose repr itself contains
`: ` (an Enum member, say) is therefore taken as one `plain` line rather
than a `pair`; dict bodies accept such bare elements so the rest of the file
still parses.

## Development

```sh
make test              # tree-sitter generate && tree-sitter test
make compile           # cc with -Wall -Wextra -Werror
make parse-all DIR=~/git/some-repo   # error stats over real snapshot files
```

`src/parser.c` is committed so nvim-treesitter can build the parser without
the tree-sitter CLI. Regenerate it after any change to `grammar.js` (CI checks
that it is up to date).

## Neovim

Registered in `.config/nvim/lua/pconfig/treesitter.lua` as a local parser;
the queries in `queries/ambr/` (highlights, folds, indents, `context.scm`
for nvim-treesitter-context, and injections that highlight container values
with the Python grammar and YAML-looking `'''` strings with the YAML one) are picked up because this directory is on the
runtimepath as a lazy.nvim plugin.
