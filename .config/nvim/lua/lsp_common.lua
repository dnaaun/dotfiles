--- null-ls.nvim sometimes conflicts with other LSPs
local disable_formatting_sometimes = function(client)
	if not (client.name == "rust_analyzer" or client.name == "texlab" or client.name == "null-ls") then
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	else
		-- print("LSP formatting NOT disabled for " .. client.name)
	end
end

-- Use LSP formatting. Note this doesn't get invoked if LSP
-- isn't attached since we call it in on_attach
local setup_formatexpr = function(client)
	if not client.document_range_formatting then
		return 1
	end

	_G.lsp_formatexpr = function()
		-- only reformat on explicit gq command
		local mode = vim.fn.mode()
		if mode == "i" then
			-- fall back to Vims internal reformatting if in insert mode
			return 1
		end

		local opts = {}
		local start_line = vim.v.lnum
		local end_line = start_line + vim.v.count - 1
		if start_line >= 0 and end_line >= 0 then
			vim.lsp.buf.range_formatting(opts, { start_line, 0 }, { end_line, 0 })
		end
		return 0
	end

	vim.bo.formatexpr = "v:lua._G.lsp_formatexpr()"
end

-- Allow other files to define callbacks that get called `on_attach`
local on_attach = function(client, bufnr)
	-- go to next/previous occurence of variable under cursor using g* and g#
	-- require("lsp_occurence").on_attach(client, bufnr)

	-- for _, plugin_custom_attach in pairs(_G.lsp_config_on_attach_callbacks) do
	-- 	plugin_custom_attach(client)
	-- end

	-- setup_mappings(bufnr)
	setup_formatexpr(client)
	disable_formatting_sometimes(client)
end

return {
	on_attach = on_attach,
}
