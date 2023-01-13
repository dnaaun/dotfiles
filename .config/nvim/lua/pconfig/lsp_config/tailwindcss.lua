return {
	filetypes = vim.list_extend({ "rust" }, require("consts").javascripty_filetypes),
	init_options = {
		userLanguages = {
			rust = "rust",
		},
	},
	settings = {
		tailwindCSS = {
			includeLanguages = {
				rust = "html",
			},
			emmetCompletions = true,
			classAttributes = { "class", "className", "classList", "ngClass" },
			lint = {},
			validate = true,
		},
	},
}
