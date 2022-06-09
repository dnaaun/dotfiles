return {
	"neovim/nvim-lspconfig",
	ft = require("consts").lsp_enabled_filetypes,
	config = function()
		local buf_mapfunc = require("std2").buf_mapfunc
		-- Keybindings
		local setup_mappings = function(bufnr)
			local opts = { noremap = true, silent = true }
			vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
			vim.api.nvim_buf_set_keymap(bufnr, "n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
			buf_mapfunc("n", "gh", function()
				vim.diagnostic.open_float({ source = true })
			end, opts, "show line diagnostics")
			vim.api.nvim_buf_set_keymap(0, "n", "[e", "<cmd>lua vim.diagnostic.goto_prev({severity='Error'})<CR>", opts)
			vim.api.nvim_buf_set_keymap(0, "n", "]e", "<cmd>lua vim.diagnostic.goto_next({severity='Error'})<CR>", opts)
			vim.keymap.set("n", "<leader>lf", function()
				vim.lsp.buf.format({ async = true })
			end, { buffer = true })
			vim.keymap.set("n", "<leader>la", function()
				vim.lsp.buf.code_action({})
			end)
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

		--- null-ls.nvim sometimes conflicts with other LSPs
		local disable_formatting_sometimes = function(client)
			if not (client.name == "rust_analyzer" or client.name == "texlab" or client.name == "null-ls") then
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			else
				-- print("LSP formatting NOT disabled for " .. client.name)
			end
		end

		--  We need to do this after the LSP is attached because otherwise inlay_hints doesn't work.
		local rust_tools_activate = function(client)
			if client.name == "rust_analyzer" then
				-- require("rust-tools.inlay_hints").set_inlay_hints()
			end
		end

		-- Allow other files to define callbacks that get called `on_attach`
		local on_attach = function(client, bufnr)
			for _, plugin_custom_attach in pairs(_G.lsp_config_on_attach_callbacks) do
				plugin_custom_attach(client)
			end

			setup_mappings(bufnr)
			setup_formatexpr(client)
			disable_formatting_sometimes(client)
			rust_tools_activate(client)
		end

		-- Config for all LSPs
		local common_config = {
			on_attach = on_attach,
		}
		-- Needed for sumenko
		local sumneko_root_path = vim.fn.expand("~") .. "/src/lua-language-server"
		local sumneko_binary = sumneko_root_path .. "/bin/" .. "/lua-language-server"

		local runtime_path = vim.split(package.path, ";")
		table.insert(runtime_path, "lua/?.lua")
		table.insert(runtime_path, "lua/?/init.lua")

		local lspconfig = require("lspconfig")

		-- Configuration for each LSP
		local lsp_specific_configs = {
			rust_analyzer = {
				settings = {
					["rust-analyzer"] = {
						cargo = {},
					},
				},
			},
			html = {
				cmd = { "vscode-html-language-server", "--stdio" },
				filetypes = { "html" },
				init_options = {
					configurationSection = { "html", "css", "javascript" },
					embeddedLanguages = {
						css = true,
						javascript = true,
					},
				},
				root_dir = lspconfig.util.root_pattern(".git") or vim.loop.os_homedir(),
				settings = {},
			},
			sumnko_lua = {
				settings = {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
							-- Setup your lua path
							path = runtime_path,
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = {
								"vim",
                -- The rest of these globals were taken from luasnip: https://github.com/L3MON4D3/Dotfiles/blob/1214ff2bbb567fa8bdd04a21976a1a64ae931330/.config/nvim/lua/plugins/lspconfig.lua#L155-L168
								"s",
								"sn",
								"t",
								"i",
								"f",
								"c",
								"end",
								"d",
								"isn",
								"psn",
								"l",
								"rep",
								"r",
								"p",
								"types",
								"events",
								"util",
								"fmt",
								"ls",
								"ins_generate",
								"parse",
							},
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file("", true),
						},
						-- Do not send telemetry data containing a randomized but unique identifier
						telemetry = {
							enable = false,
						},
					},
				},
			},
			kotlin_language_server = {
				cmd = {
					vim.fn.expand("~")
						.. "/src/kotlin-language-server/server/build/install/server/bin/kotlin-language-server",
				},
				root_dir = lspconfig.util.root_pattern("settings.gradle.kts") or lspconfig.util.root_pattern(
					"settings.gradle"
				),
			},

			texlab = {
				settings = {
					texlab = {
						auxDirectory = ".",
						bibtexFormatter = "texlab",
						chktex = {
							onEdit = false,
							onOpenAndSave = false,
						},
						diagnosticsDelay = 300,
						formatterLineLength = 80,
						forwardSearch = {
							executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
							args = { "-g", "%l", "%p", "%f" },
						},
						latexFormatter = "latexindent",
						latexindent = {
							modifyLineBreaks = true,
						},
						build = {
							args = { "%f", "--synctex" },
							executable = "tectonic",
							forwardSearchAfter = true,
							onSave = true,
						},
					},
				},
			},

			sqlls = {
				cmd = { "sql-language-server", "up", "--method", "stdio" },
			},

			sqls = {
				cmd = { "sqls" },
				filetypes = { "sql", "mysql" },
				settings = {},
				single_file_support = true,
			},

			sumneko_lua = {
				cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
				settings = {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
							-- Setup your lua path
							path = runtime_path,
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global, and `use` from packer.nvim
							globals = { "vim", "use" },
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file("", true),
						},
						-- Do not send telemetry data containing a randomized but unique identifier
						telemetry = {
							enable = false,
						},
					},
				},
			},

			sorbet = {
				cmd = { "bundle", "exec", "srb", "tc", "--lsp" },
				filetypes = { "ruby" },
				root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
			},
		}

		-- https://github.com/ms-jpq/coq_nvim#lsp
		-- local coq = require("coq")

		for _, lspname in ipairs({
			"clangd",
			"dockerls",
      "eslint",
			"kotlin_language_server",
			"pyright",
			"rust_analyzer",
			"solargraph",
			"sqls",
			"sumneko_lua",
			"tailwindcss",
			"texlab",
			"tsserver",
			"vimls",
			-- "sorbet",
		}) do
			local config = lsp_specific_configs[lspname]
			if config ~= nil then
				config = vim.tbl_extend("force", common_config, config)
			else
				config = common_config
			end
			-- lspconfig[lspname].setup(coq.lsp_ensure_capabilities(config))

			-- Setup nvim-cmp
			local capabilities = require("cmp_nvim_lsp").update_capabilities(
				vim.lsp.protocol.make_client_capabilities()
			)
			lspconfig[lspname].setup(vim.tbl_extend("force", config, {
				capabilities = capabilities,
			}))
		end
	end,
}
