---
description: "jj util exec - Execute an external command via jj"
---

# jj util exec

Execute an external command via jj.

This command will have access to the environment variable JJ_WORKSPACE_ROOT. This is useful for arbitrary aliases.

**WARNING**: This just provides a convenient syntax for running arbitrary code on your system. Exercise caution.

## Usage

```
jj util exec [OPTIONS] <COMMAND> [ARGS]...
```

## Arguments

- `<COMMAND>` - The command to execute
- `[ARGS]...` - Arguments to pass to the command

## Options

```
-h, --help    Print help
```

## Example

Add this to your configuration file:
```toml
[aliases]
my-script = ["util", "exec", "--", "my-jj-script"]
```

Inline script:
```toml
[aliases]
my-inline-script = ["util", "exec", "--", "bash", "-c", """
set -euo pipefail
echo "Look Ma, everything in one file!"
echo "args: $@"
""", ""]
```
