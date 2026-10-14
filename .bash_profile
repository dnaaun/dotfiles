# Apparently I need this on MacOS
source ~/.bashrc

# Added by swiftly
. "/Users/david/.swiftly/env.sh"
# Added by Antigravity
export PATH="/Users/david/.antigravity/antigravity/bin:$PATH"

# Hermes Agent command
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) export PATH="$HOME/.local/bin:$PATH" ;; esac
