-- Helper functions from the original config
local disable_formatting_sometimes = function(client)
	if not (client.name == "rust_analyzer" or client.name == "texlab" or client.name == "null-ls") then
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end
end

local setup_formatexpr = function(client)
	if not client.document_range_formatting then
		return 1
	end

	_G.lsp_formatexpr = function()
		local mode = vim.fn.mode()
		if mode == "i" then
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

local setup_texlab_forward_search = function()
	local wk = require("which-key")
	wk.add({ { "<leader>t", ":TexlabForward<CR>", desc = "Texlab forward" } })
end

-- Global on_attach function
local on_attach = function(client, bufnr)
	if client.name == "texlab" then
		setup_texlab_forward_search()
	end

	if client.name == "ts_ls" then
		local wk = require("which-key")
		wk.add({
			{
				"<leader>li",
				function()
					vim.lsp.buf.execute_command({
						command = "_typescript.organizeImports",
						arguments = { vim.fn.expand("%:p") },
					})
				end,
				desc = "TS Organize Imports",
			},
		})
	end

	require("lsp_occurence").on_attach(client, bufnr)

	for _, plugin_custom_attach in pairs(_G.lsp_config_on_attach_callbacks or {}) do
		plugin_custom_attach(client)
	end

	setup_formatexpr(client)
end

return {
	-- Since we're not using nvim-lspconfig anymore, this is just a regular setup function
	setup = function()
		-- Setup keymaps (from original config)
		local wk = require("which-key")
		wk.add({
			{ "K", vim.lsp.buf.hover, desc = "hover" },
			{ "gR", vim.lsp.buf.rename, desc = "rename" },
			{
				"gh",
				function()
					vim.diagnostic.open_float({ source = true })
				end,
				desc = "diagnostic float",
			},
			{
				"[e",
				function()
					vim.diagnostic.goto_prev({ severity = "Error" })
				end,
				desc = "previous diagnostic",
			},
			{
				"]e",
				function()
					vim.diagnostic.goto_next({ severity = "Error" })
				end,
				desc = "next diagnostic",
			},
			{
				"[gh",
				function()
					vim.diagnostic.goto_prev({ severity = "Warn" })
				end,
				desc = "previous diagnostic",
			},
			{
				"]gh",
				function()
					vim.diagnostic.goto_next({ severity = "Warn" })
				end,
				desc = "next diagnostic",
			},
		})

		-- Global configuration for all LSP clients
		vim.lsp.config("*", {
			on_attach = on_attach,
			root_markers = { ".git" },
		})

		-- Load individual server configurations and apply them
		local lsp_specific_configs = {
			rust_analyzer = require("pconfig.lsp_config.rust_analyzer"),
			html = require("pconfig.lsp_config.html"),
			kotlin_language_server = require("pconfig.lsp_config.kotlin_language_server"),
			texlab = require("pconfig.lsp_config.texlab"),
			ts_ls = require("pconfig.lsp_config.ts_ls"),
			postgres_lsp = require("pconfig.lsp_config.postgres_lsp"),
			eslint = require("pconfig.lsp_config.eslint"),
			sorbet = require("pconfig.lsp_config.sorbet"),
			ruby_ls = require("pconfig.lsp_config.ruby_ls"),
			tinymist = require("pconfig.lsp_config.tinymist"),
			basedpyright = require("pconfig.lsp_config.basedpyright"),
			sourcekit = require("pconfig.lsp_config.sourcekit"),
		}

		-- Configure servers with their specific configs
		for server_name, config in pairs(lsp_specific_configs) do
			-- Merge with global on_attach if the server has its own on_attach
			if config.on_attach then
				local server_on_attach = config.on_attach
				config.on_attach = function(client, bufnr)
					on_attach(client, bufnr)
					server_on_attach(client, bufnr)
				end
			end

			vim.lsp.config(server_name, config)
		end

		-- Custom AST-grep LSP
		vim.lsp.config("ast_grep", {
			cmd = { "sg", "lsp" },
			filetypes = {},
			single_file_support = true,
			root_dir = function(fname)
				return vim.fs.find({ ".git", "sgconfig.yml" }, {
					path = fname,
					upward = true,
				})[1] and vim.fs.dirname(vim.fs.find({ ".git", "sgconfig.yml" }, {
					path = fname,
					upward = true,
				})[1])
			end,
		})

		-- Enable all configured servers
		local servers_to_enable = {
			"clangd",
			"dockerls",
			"eslint",
			"kotlin_language_server",
			"basedpyright",
			"postgres_lsp",
			"rust_analyzer",
			"texlab",
			"html",
			"sorbet",
			"tinymist",
			"yamlls",
			"sourcekit",
		}

		for _, server in ipairs(servers_to_enable) do
			vim.lsp.enable(server)
		end

		-- Diagnostic handler fix (from original config)
		for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
			local default_diagnostic_handler = vim.lsp.handlers[method]
			vim.lsp.handlers[method] = function(err, result, context, config)
				if err ~= nil and err.code == -32802 then
					return
				end
				return default_diagnostic_handler(err, result, context, config)
			end
		end
	end,
}
