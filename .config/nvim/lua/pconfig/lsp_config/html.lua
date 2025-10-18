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
	root_dir = function(fname)
		return vim.fs.find({ '.git' }, {
			path = fname,
			upward = true
		})[1] and vim.fs.dirname(vim.fs.find({ '.git' }, {
			path = fname,
			upward = true
		})[1]) or vim.fn.expand('~')
	end,
	settings = {},
}