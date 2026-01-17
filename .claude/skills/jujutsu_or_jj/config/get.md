---
description: "jj config get - Get the value of a given config option [alias: g]"
---

# jj config get

Get the value of a given config option.

Unlike `jj config list`, the result of `jj config get` is printed without extra formatting and therefore is usable in scripting.

## Example

```
$ jj config list user.name
user.name="Martin von Zweigbergk"
$ jj config get user.name
Martin von Zweigbergk
```

## Usage

```
jj config get [OPTIONS] <NAME>
```

## Arguments

- `<NAME>` - The config option name

## Options

```
-h, --help    Print help
```
