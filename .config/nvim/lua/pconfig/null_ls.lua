return {
	"nvimtools/none-ls.nvim",
	-- event = { "InsertLeave", "CursorHold" },
	dependencies = { "plenary.nvim" },
	config = function()
		local null_ls = require("null-ls")
		local helpers = require("null-ls.helpers")

		null_ls.register({ name = "pgsanity", sources = { pgsanity }, debounce = 2000 })

		null_ls.setup({
			debug = false,
			debounce = 3000, -- 2 secs after the dust settles, fire off diagnostics.
			fallback_severity = vim.diagnostic.severity.WARN,
			sources = {
				null_ls.builtins.formatting.pg_format,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.prettier.with({
					filetypes = vim.list_extend({ "css" }, require("consts").javascripty_filetypes),
				}),
				null_ls.builtins.diagnostics.rubocop.with({
					command = { "bundle", "exec", "rubocop" },
				}),
				null_ls.builtins.formatting.rubocop.with({
					command = { "bundle", "exec", "rubocop" },
				}),
				-- null_ls.builtins.formatting.rubyfmt,
				null_ls.builtins.diagnostics.haml_lint,
				null_ls.builtins.formatting.djlint,
			},
		})
	end,
}
