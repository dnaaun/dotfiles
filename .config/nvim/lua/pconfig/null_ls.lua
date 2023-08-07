return {
	"jose-elias-alvarez/null-ls.nvim",
	event = { "InsertLeave", "CursorHold" },
	dependencies = { "plenary.nvim" },
	config = function()
		local null_ls = require("null-ls")

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
				null_ls.builtins.diagnostics.rubocop,
				null_ls.builtins.formatting.rubocop,
				null_ls.builtins.diagnostics.haml_lint,
				null_ls.builtins.diagnostics.sqlfluff.with({
					extra_args = { "--dialect", "sqlite" }, -- change to your dialect
				}),
				null_ls.builtins.formatting.djlint,
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

    -- I think Solargraph (through Rubocop) reports syntax errors now?
		-- null_ls.register({ name = "ruby-syntax", sources = { ruby_syntax_check }, debounce = 4000 })
	end,
}
