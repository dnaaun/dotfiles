---
description: "jj config set - Update a config file to set the given option [alias: s]"
---

# jj config set

Update a config file to set the given option to a given value.

## Usage

```
jj config set [OPTIONS] <--user|--repo> <NAME> <VALUE>
```

## Arguments

- `<NAME>` - The config option name
- `<VALUE>` - New value to set (specified as a TOML expression)

## Options

```
--user    Target the user-level config
--repo    Target the repo-level config
-h, --help    Print help
```

## Example

```bash
jj config set --user user.name "Your Name"
jj config set --user user.email "you@example.com"
```
