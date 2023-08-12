local root_pattern = require("lspconfig").util.root_pattern;

return {
	cmd = { "sorbet", "tc", "--lsp", "--disable-watchman" },
	filetypes = { "ruby" },
	root_dir = root_pattern("Gemfile", ".git"),
}
