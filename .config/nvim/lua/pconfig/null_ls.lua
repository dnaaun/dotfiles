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
				null_ls.builtins.formatting.pg_format,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.prettier.with({
					filetypes = vim.list_extend({ "css" }, require("consts").javascripty_filetypes),
				}),
				null_ls.builtins.diagnostics.rubocop,
				null_ls.builtins.formatting.rubocop,
				null_ls.builtins.diagnostics.haml_lint,
			},
		})

		local helpers = require("null-ls.helpers")

		local ruby_syntax_check = {
			method = null_ls.methods.DIAGNOSTICS,
			filetypes = { "ruby" },
			generator = helpers.generator_factory({
				args = { "-c" },
				command = "ruby",
				format = "line",
				from_stderr = true,
				check_exit_code = function(code)
					local success = code <= 1
					return success
				end,
				to_stdin = true,
				on_output = helpers.diagnostics.from_pattern([[.*:(%d+): (.*)]], { "row", "message" }, {
					diagnostic = {
						severity = helpers.diagnostics.severities.error,
					},
				}),
			}),
		}

		null_ls.register({ name = "ruby-syntax", sources = { ruby_syntax_check } })
	end,
}
