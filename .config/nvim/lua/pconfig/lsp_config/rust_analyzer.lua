local expand_macro = function()
	vim.lsp.buf_request_all(0, "rust-analyzer/expandMacro", vim.lsp.util.make_position_params(), function(result)
		vim.cmd("vsplit")
		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_win_set_buf(0, buf)

		if result then
			vim.api.nvim_set_option_value("filetype", "rust", { buf = 0 })
			for client_id, res in pairs(result) do
				if res and res.result and res.result.expansion then
					vim.api.nvim_buf_set_lines(buf, -1, -1, false, vim.split(res.result.expansion, "\n"))
				else
					vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "No expansion available." })
				end
			end
		else
			vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "Error: No result returned." })
		end
	end)
end

return {
	on_attach = function(client, bufnr)
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end,
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	commands = {
		ExpandMacro = { expand_macro },
	},
	settings = {
		["rust-analyzer"] = {
			cargo = {
				features = { "ssr", "hydrate" },
				noDefaultFeatures = false,
				allFeatures = false,
			},
			check = {
				command = "check",
				allTargets = true,
				extraArgs = {
					"--profile",
					"rust-analyzer",
				},
			},
			rustfmt = {
				extraArgs = {
					"--profile",
					"rust-analyzer",
				},
			},
		},
	},
}
