return {
	"jose-elias-alvarez/null-ls.nvim",
	requires = { "plenary.nvim" },

	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			debug = false,
			debounce = 2000, -- 2 secs after the dust settles, fire off diagnostics.
			fallback_severity = vim.diagnostic.severity.WARN, -- Currently entirely for the sake of eslint "errors" that I'd like reported as warnings.
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.prettier.with({
					filetypes = vim.list_extend({ "css" }, require("consts").javascripty_filetypes),
				}),
				null_ls.builtins.diagnostics.rubocop,
				-- null_ls.builtins.formatting.rubocop,
				null_ls.builtins.diagnostics.haml_lint,
				null_ls.builtins.formatting.rufo,
				-- null_ls.builtins.diagnostics.sqlfluff.with({
				-- 	extra_args = { "--dialect", "postgres" }, -- change to your dialect
				-- }),
				-- null_ls.builtins.formatting.sqlfluff.with({
				-- 	extra_args = { "--dialect", "postgres" }, -- change to your dialect
				-- }),
			},
		})
	end,
}
