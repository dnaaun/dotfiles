return {
	"nvimtools/none-ls.nvim",
	-- event = { "InsertLeave", "CursorHold" },
	dependencies = { "plenary.nvim" },
	config = function()
		local null_ls = require("null-ls")
		local helpers = require("null-ls.helpers")

		local pgsanity = { method = null_ls.methods.DIAGNOSTICS,
			filetypes = { "sql" },
			generator = helpers.generator_factory({
				command = "pgsanity",
				format = "line",
				from_stderr = true,
				check_exit_code = function(code)
					local success = code <= 1
					return success
				end,
				to_stdin = true,
				on_output = helpers.diagnostics.from_pattern([[line (%d+): .*: (.*)]], { "row",
					-- "severity",
					"message",
				}, {}),
			}),
		}
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
				null_ls.builtins.diagnostics.haml_lint,
				null_ls.builtins.formatting.djlint,
			},
		})


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
