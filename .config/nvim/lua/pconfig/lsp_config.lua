local wk = require("which-key")

-- method 3
wk.register({
	K = { vim.lsp.buf.hover, "hover" },
	g = {
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
	["[lh"] = {
		function()
			vim.diagnostic.goto_prev({ severity = "Warn" })
		end,
		"previous diagnostic",
	},
	["]lh"] = {
		function()
			vim.diagnostic.goto_next({ severity = "Warn" })
		end,
		"next diagnostic",
	},
	["<leader>l"] = {
		f = {
			function()
				vim.lsp.buf.format({ async = true })
			end,
			"format",
		},
		a = {
			function()
				vim.lsp.buf.code_action({})
			end,
			"code action",
		},
	},
}, { mode = "n" })

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

		--- null-ls.nvim sometimes conflicts with other LSPs
		local disable_formatting_sometimes = function(client)
			if not (client.name == "rust_analyzer" or client.name == "texlab" or client.name == "null-ls") then
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			else
				-- print("LSP formatting NOT disabled for " .. client.name)
			end
		end

		-- Allow other files to define callbacks that get called `on_attach`
		local on_attach = function(client, bufnr)
			-- go to next/previous occurence of variable under cursor using g* and g#
			require("lsp_occurence").on_attach(client, bufnr)

			for _, plugin_custom_attach in pairs(_G.lsp_config_on_attach_callbacks) do
				plugin_custom_attach(client)
			end

			-- setup_mappings(bufnr)
			setup_formatexpr(client)
			disable_formatting_sometimes(client)
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
			-- Tring out rust-tools right now
			rust_analyzer = {
				settings = {
					["rust-analyzer"] = {
						diagnostics = {
							enable = true,
							disabled = { "unresolved-proc-macro" },
							-- enableExperimental = true,
						},
						cargo = {},
						-- checkOnSave = {
						-- 	command = "clippy",
						-- },
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
							args = { "%l", "%p", "%f" },
						},
						latexFormatter = "latexindent",
						latexindent = {
							modifyLineBreaks = true,
						},
						build = {
							args = { "--synctex", "%f" },
							executable = "tectonic",
							forwardSearchAfter = true,
							onSave = false,
						},
					},
				},
			},

			tsserver = {
				filetypes = require("consts").javascripty_filetypes,
				init_options = { codeActionsOnSave = { source = { organizeImports = true } } },
			},

			tailwindcss = {
				filetypes = require("consts").javascripty_filetypes,
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
			eslint = {
				filetypes = require("consts").javascripty_filetypes,
			},
		}

		-- https://github.com/ms-jpq/coq_nvim#lsp
		-- local coq = require("coq")

		for _, lspname in ipairs({
     -- "ccls",
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
