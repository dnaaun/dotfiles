return {
	-- Filetypes for which we have LSPs configured
	lsp_enabled_filetypes = {
		"typescript",
		"typescriptreact",
		"javascript",
		"javascriptreact",
		"tsx",
		"typescript",
		"ruby",
		"react",
		"python",
		"lua",
		"tex",
		"cpp",
		"rust",
		"dockerfile",
	},

	-- For the nvim-dap plugin
	dap_enabled_filetypes = {
		"python",
		"ruby",
	},

	javascripty_filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"tsx", -- Basically only to add this, I modified the defualt.
		"vue",
		"less",
		"html",
		"json",
		"jsonc",
		"yaml",
		"markdown",
		"graphql",
		"handlebars",
		"svelte",
	},
}
