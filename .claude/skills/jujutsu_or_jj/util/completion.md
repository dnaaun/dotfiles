---
description: "jj util completion - Print a command-line-completion script"
---

# jj util completion

Print a command-line-completion script.

Apply it by running one of these:

- Bash: `source <(jj util completion bash)`
- Fish: `jj util completion fish | source`
- Nushell:
  ```nu
  jj util completion nushell | save "completions-jj.nu"
  use "completions-jj.nu" *
  ```
- Zsh:
  ```shell
  autoload -U compinit
  compinit
  source <(jj util completion zsh)
  ```

See: https://jj-vcs.github.io/jj/latest/install-and-setup/#command-line-completion

## Usage

```
jj util completion [OPTIONS] <SHELL>
```

## Arguments

- `<SHELL>` - [possible values: bash, elvish, fish, nushell, power-shell, zsh]

## Options

```
-h, --help    Print help
```
