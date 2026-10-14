# Fn superscript digits (macOS)

Karabiner maps Fn+1 through Fn+9 and Fn+0 to Unicode superscript digits.
The native Swift helper posts Unicode keyboard events without using the clipboard.

Files are installed by the repository's setupdotfiles symlink script:
- `.config/karabiner/karabiner.json`
- `.local/bin/fn-superscript` (launcher)
- `.local/share/fn-superscripts/main.swift`

The launcher compiles with `xcrun swiftc` when needed and caches the binary in
`${XDG_CACHE_HOME:-$HOME/Library/Caches}/fn-superscripts/`. Generated binaries
are not tracked. Requires macOS, Xcode Command Line Tools, Karabiner-Elements,
and Accessibility permission for event posting.

Check installation: `~/.local/bin/fn-superscript --check`
