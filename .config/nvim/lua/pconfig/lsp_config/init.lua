--- null-ls.nvim sometimes conflicts with other LSPs
local disable_formatting_sometimes = function(client)
	if not (client.name == "rust_analyzer" or client.name == "texlab" or client.name == "null-ls") then
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	else
		-- print("LSP formatting NOT disabled for " .. client.name)
	end
end

return {
	"neovim/nvim-lspconfig",
	-- lazy = true,
	-- event = {
	-- 	-- from the auto-session plugin
	-- 	"SessionLoadPost",
	-- 	"BufEnter",
	-- 	"VeryLazy",
	-- },
	dependencies = { "folke/which-key.nvim" }, -- for a mpping in on-attach below.
	-- ft = require("consts").lsp_enabled_filetypes,
	opts = { inlay_hints = { enabled = true } },
	config = function()
		-- https://ast-grep.github.io/guide/editor-integration.html#nvim-lspconfig
		local configs = require("lspconfig.configs")
		configs.ast_grep = {
			default_config = {
				cmd = { "sg", "lsp" },
				filetypes = {
					-- "typescript", "typescriptreact", "javascript", "javascriptreact"
				},
				single_file_support = true,
				root_dir = require("lspconfig").util.root_pattern(".git", "sgconfig.yml"),
			},
		}
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
		vim.lsp.set_log_level(vim.lsp.log_levels.INFO)

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

		-- A func to setup a mapping for :TexlabForward
		local setup_texlab_forward_search = function()
			local opts = { noremap = true, silent = true }
			wk.add({ { "<leader>t", ":TexlabForward<CR>", desc = "Texlab forward" } }, opts)
		end

		-- Allow other files to define callbacks that get called `on_attach`
		local on_attach = function(client, bufnr)
			-- In typescript projects, I think two different formatters (or at least formatting configs)
			-- are being used, and their order is inconsistent across nvim invocations.
			-- I hoped it was because prettier and typescript-language-server were both formatting, and so
			-- I disabled the typescript-language-server formatting, but that didn't seem to help.
			-- I'll just keep this here though. It can't make it worse.
			-- disable_formatting_sometimes(client)

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

		-- Config for all LSPs
		local common_config = {
			on_attach = on_attach,
		}

		local lspconfig = require("lspconfig")

		local lsp_specific_configs = {
			rust_analyzer = require("pconfig.lsp_config.rust_analyzer"),
			html = require("pconfig.lsp_config.html"),
			-- cssls = require("pconfig.lsp_config.cssls"),
			kotlin_language_server = require("pconfig.lsp_config.kotlin_language_server"),
			texlab = require("pconfig.lsp_config.texlab"),
			ts_ls = require("pconfig.lsp_config.ts_ls"),
			tailwindcss = require("pconfig.lsp_config.tailwindcss"),
			sqls = require("pconfig.lsp_config.sqls"),
			efm = require("pconfig.lsp_config.efm"),
			sumneko_lua = require("pconfig.lsp_config.sumneko_lua"),
			sorbet = require("pconfig.lsp_config.sorbet"),
			ruby_ls = require("pconfig.lsp_config.ruby_ls"),
			eslint = require("pconfig.lsp_config.eslint"), -- requires npm i -g vscode-langservers-extracted
			tinymist = require("pconfig.lsp_config.tinymist"),
		}

		for _, lspname in ipairs({
			"clangd",
			"dockerls",
			"eslint",
			"kotlin_language_server",
			"basedpyright",
			-- Until I figure out how to route specific requests to specific servers,
			-- I'll use only sorbet for ruby.
			-- "solargraph",
			-- "efm", -- seems to cause issuse on MacOS
			"sqls",
			"rust_analyzer",
			-- "sumneko_lua",
			-- "tailwindcss",
			"texlab",
			"ts_ls",
			"html",
			"sorbet",
			-- "cssls",
			"tinymist",
			-- "jsonls",
			-- "marksman",
			"yamlls",
			-- "ast_grep",
      "sourcekit"
		}) do
			local config = lsp_specific_configs[lspname]
			if config ~= nil then
				config = vim.tbl_extend("force", common_config, config)
			else
				config = common_config
			end

			lspconfig[lspname].setup(config)
		end

		-- https://github.com/neovim/neovim/issues/30985#issuecomment-2447329525
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
