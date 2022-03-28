return {
	"jose-elias-alvarez/null-ls.nvim",
	requires = { "plenary.nvim" },

	config = function()
		require("null-ls").setup({
			debug = false,
			debounce = 2000, -- 2 secs after the dust settles, fire off diagnostics.
			fallback_severity = vim.diagnostic.severity.WARN, -- Currently entirely for the sake of eslint "errors" that I'd like reported as warnings.
			sources = {
				require("null-ls").builtins.formatting.stylua,
				require("null-ls").builtins.formatting.black,
				require("null-ls").builtins.formatting.prettier,
				require("null-ls").builtins.diagnostics.rubocop,
				require("null-ls").builtins.diagnostics.haml_lint,
				require("null-ls").builtins.formatting.rufo,
				require("null-ls").builtins.diagnostics.eslint_d, --.with({ method = require("null-ls").methods.DIAGNOSTICS_ON_SAVE, }),

			},
		})
	end,
}
