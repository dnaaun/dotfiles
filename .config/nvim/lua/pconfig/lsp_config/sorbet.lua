local root_pattern = require("lspconfig").util.root_pattern;

return {
	cmd = { "bundle", "exec", "srb", "tc", "--lsp" },
	filetypes = { "ruby" },
	root_dir = root_pattern("Gemfile", ".git"),
}
