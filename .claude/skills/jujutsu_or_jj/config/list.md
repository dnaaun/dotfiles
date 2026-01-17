---
description: "jj config list - List variables set in config files [alias: l]"
---

# jj config list

List variables set in config files, along with their values.

## Usage

```
jj config list [OPTIONS] [NAME]
```

## Arguments

- `[NAME]` - An optional name of a specific config option to look up

## Options

```
--include-defaults      Include built-in default values in the list

--include-overridden    Allow printing overridden values

--user                  Target the user-level config

--repo                  Target the repo-level config

-T, --template <TEMPLATE>   Render each variable using the given template

-h, --help              Print help
```
