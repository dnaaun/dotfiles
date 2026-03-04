#!/usr/bin/env bash
# Regenerate cached shell init output.
# Run this after updating fzf, jj, direnv, or zoxide.
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
echo "Regenerating bashrc cache in $DIR ..."
fzf --bash > "$DIR/fzf.bash"
jj util completion bash > "$DIR/jj.bash"
direnv hook bash > "$DIR/direnv.bash"
zoxide init bash > "$DIR/zoxide.bash"
echo "Done."
