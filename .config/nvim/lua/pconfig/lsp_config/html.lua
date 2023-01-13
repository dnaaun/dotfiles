return {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true,
		},
	},
	root_dir = require("lspconfig").util.root_pattern(".git") or vim.loop.os_homedir(),
	settings = {},
}
