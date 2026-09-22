# Regenerate src/parser.c from grammar.js (needs the tree-sitter CLI).
generate:
	tree-sitter generate

# Corpus tests under test/corpus, and highlight assertions if any.
test: generate
	tree-sitter test

# Fails if src/ is stale relative to grammar.js; run `make generate` and commit.
check-generated: generate
	@if ! git diff --quiet -- src; then \
		echo "src/ is out of date; run 'make generate' and commit the result"; \
		git --no-pager diff --stat -- src; \
		exit 1; \
	fi

# Compile the parser the way nvim-treesitter does, to catch C warnings early.
compile:
	cc -std=c11 -Wall -Wextra -Werror -shared -fPIC -o /dev/null -I src src/parser.c src/scanner.c

# Parse every .ambr file found under $(DIR) (default: current directory) and
# report how many have syntax errors.
parse-all:
	fd -e ambr . $(or $(DIR),.) | tree-sitter parse --quiet --stat --paths /dev/stdin

.PHONY: generate test check-generated compile parse-all
