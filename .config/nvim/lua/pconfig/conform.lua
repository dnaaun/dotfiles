-- Define a function to set your key mappings

vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("MyMappings", { clear = true }),
	callback = function()
		local format_with_conform = function(args)
			local range = nil
			if args ~= nil and args.count ~= -1 then
				local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
				range = {
					start = { args.line1, 0 },
					["end"] = { args.line2, end_line:len() },
				}
			end
			require("conform").format({
				async = true,
				lsp_format = "fallback",
				range = range,
				callback = function()
					require("lint").try_lint()
				end,
			})
		end

    -- orgmode.nvim provides it's own formatexpr that I don't wanna mess with.
		if vim.bo.filetype ~= "org" then
			vim.keymap.set("n", "gql", format_with_conform, { desc = "format with conform" })
			vim.keymap.set("v", "gql", format_with_conform, { desc = "format with conform" })
		end
	end,
})

return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				sql = { "pg_format" },
				lua = { "stylua" },
				python = { "ruff_fix", "ruff_format" },
				ruby = { "rubocop" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				rust = { "rustfmt", lsp_format = "fallback" },
			},
		})
	end,
}
