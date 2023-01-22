return {
	"neovim/nvim-lspconfig",
	ft = require("consts").lsp_enabled_filetypes,
	config = function()
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

		-- A function to setup a mapping for :TexlabForward
		local setup_texlab_forward_search = function()
			local map = vim.api.nvim_set_keymap
			local opts = { noremap = true, silent = true }
			map("n", "<leader>t", ":TexlabForward<CR>", opts)
		end

		local setup_mappings = function()
			local wk = require("which-key")
			wk.register({
				K = { vim.lsp.buf.hover, "hover" },
				g = {
					a = {
						function()
							vim.lsp.buf.code_action({})
						end,
						"code action",
					},
					d = { vim.lsp.buf.definition, "rename" },
					R = { vim.lsp.buf.rename, "rename" },
					h = {
						function()
							vim.diagnostic.open_float({ source = true })
						end,
						"diagnostic float",
					},
				},
				["[e"] = {
					function()
						vim.diagnostic.goto_prev({ severity = "Error" })
					end,
					"previous diagnostic",
				},
				["]e"] = {
					function()
						vim.diagnostic.goto_next({ severity = "Error" })
					end,
					"next diagnostic",
				},
				["[gh"] = {
					function()
						vim.diagnostic.goto_prev({ severity = "Warn" })
					end,
					"previous diagnostic",
				},
				["]gh"] = {
					function()
						vim.diagnostic.goto_next({ severity = "Warn" })
					end,
					"next diagnostic",
				},
				["gql"] = {
					function()
						vim.lsp.buf.format({ async = true })
					end,
					"format",
				},
			}, { mode = "n" })
		end

		setup_mappings()

		-- Allow other files to define callbacks that get called `on_attach`
		local on_attach = function(client, bufnr)
			require("lsp_occurence").on_attach(client, bufnr)

			for _, plugin_custom_attach in pairs(_G.lsp_config_on_attach_callbacks) do
				plugin_custom_attach(client)
			end

			-- setup_mappings(bufnr)
			setup_formatexpr(client)

			if client.name == "texlab" then
				setup_texlab_forward_search()
			end
		end

		-- Config for all LSPs
		local common_config = {
			on_attach = on_attach,
		}

		local lspconfig = require("lspconfig")

		local lsp_specific_configs = {
			rust_analyzer = require("pconfig.lsp_config.rust_analyzer"),
			html = require("pconfig.lsp_config.html"),
			kotlin_language_server = require("pconfig.lsp_config.kotlin_language_server"),
			texlab = require("pconfig.lsp_config.texlab"),
			tsserver = require("pconfig.lsp_config.tsserver"),
			tailwindcss = require("pconfig.lsp_config.tailwindcss"),
			sqlls = require("pconfig.lsp_config.sqls"),
			sumneko_lua = require("pconfig.lsp_config.sumneko_lua"),
			sorbet = require("pconfig.lsp_config.sorbet"),
			ruby_ls = require("pconfig.lsp_config.ruby_ls"),
			eslint = require("pconfig.lsp_config.eslint"), -- requires npm i -g vscode-langservers-extracted
		}

		for _, lspname in ipairs({
			"clangd",
			"dockerls",
			"eslint",
			"kotlin_language_server",
			"pyright",
			"solargraph",
			"sqls",
			"rust_analyzer",
			"sumneko_lua",
			"tailwindcss",
			"texlab",
			"tsserver",
			"html",
			"marksman",
		}) do
			local config = lsp_specific_configs[lspname]
			if config ~= nil then
				config = vim.tbl_extend("force", common_config, config)
			else
				config = common_config
			end

			lspconfig[lspname].setup(config)
		end
	end,
}
