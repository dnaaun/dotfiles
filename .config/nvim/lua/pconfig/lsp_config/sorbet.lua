local root_pattern = require("lspconfig").util.root_pattern;

return {
	cmd = { "srb", "tc", "--lsp",
  -- Not sure I need this on linux.
  "--disable-watchman"
},
	filetypes = { "ruby" },
	root_dir = root_pattern("Gemfile", ".git"),
}
