local remove_value = require("std2").remove_value

-- Filetypes for which we have LSPs configured
local lsp_enabled_filetypes = {
	"javascript",
	"javascriptreact",
	"typescriptreact",
	"typescript",
	"ruby",
	"react",
	"python",
	"lua",
	"tex",
	"rust",
}

-- For the nvim-dap plugin
local dap_enabled_filetypes = {
	"python",
	"ruby",
}

local mapfunc = require("std2").mapfunc

require("packer").startup({
	function(use)
		-- package/plugin manager
		use({
			"wbthomason/packer.nvim",

			config = function()
				vim.api.nvim_exec(
					[[
autocmd FileType vim,lua nnoremap <buffer> <leader>ci :source %<bar>PackerInstall<CR>
autocmd FileType vim,lua nnoremap <buffer> <leader>cc :source %<CR>
]],
					false
				)
			end,
		})

		use({
			"christoomey/vim-tmux-navigator",
			cmd = {
				"TmuxNavigateDown",
				"TmuxNavigateUp",
				"TmuxNavigateLeft",
				"TmuxNavigateRight",
			},
		})

		use("embear/vim-localvimrc") -- Enable sourcing .lnvimrc files
		use({
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("indent_blankline").setup({
					space_char_blankline = " ",
					show_end_of_line = false,
				})
				vim.g.indent_blankline_buftype_exclude = { "terminal" }
			end,
		})

		-- When opening splits, let the remaining one remain "stable"
		use({
			"luukvbaal/stabilize.nvim",
			config = function()
				require("stabilize").setup()
			end,
		})

		-- LSP dependent/related
		-- The LSPConfig, the lyth, the legend
		use({
			"neovim/nvim-lspconfig",
			as = "neovim/nvim-lspconfig",
			ft = lsp_enabled_filetypes,
			config = function()
				local buf_mapfunc = require("std2").buf_mapfunc
				-- Keybindings
				local setup_mappings = function()
					local opts = { noremap = true, silent = true }
					vim.api.nvim_buf_set_keymap(0, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
					vim.api.nvim_buf_set_keymap(0, "n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
					vim.api.nvim_buf_set_keymap(0, "n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
					buf_mapfunc("n", "gh", function()
						vim.diagnostic.open_float({source=true})
					end, opts, "show line diagnostics")
					vim.api.nvim_buf_set_keymap(
						0,
						"n",
						"[e",
						"<cmd>lua vim.diagnostic.goto_prev({severity='Error'})<CR>",
						opts
					)
					vim.api.nvim_buf_set_keymap(
						0,
						"n",
						"]e",
						"<cmd>lua vim.diagnostic.goto_next({severity='Error'})<CR>",
						opts
					)
					vim.api.nvim_buf_set_keymap(0, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
				end

				-- Use LSP formatting. Note this doesn't get invoked if LSP
				-- isn't attached since we call it in on_attach
				local setup_formatexpr = function(client)
					if not client.resolved_capabilities.document_range_formatting then
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
					if
						not (
							client.name == "null-ls"
							or client.name == "rust_analyzer"
							or client.name == "solargraph"
							or client.name == "texlab"
						)
					then
						client.resolved_capabilities.document_formatting = false
						client.resolved_capabilities.document_range_formatting = false
						-- print("LSP formatting disabled for " .. client.name)
					else
						-- print("LSP formatting NOT disabled for " .. client.name)
					end
				end

				--  We need to do this after the LSP is attached because otherwise inlay_hints doesn't work.
				local rust_tools_activate = function(client)
					if client.name == "rust_analyzer" then
						require("rust-tools.inlay_hints").set_inlay_hints()
					end
				end

				-- Allow other files to define callbacks that get called `on_attach`
				local on_attach = function(client)
					for _, plugin_custom_attach in pairs(_G.lsp_config_on_attach_callbacks) do
						plugin_custom_attach(client)
					end

					setup_mappings()
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
									globals = { "vim" },
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
									forwardSearchAfter = false,
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
						cmd = { "srb", "tc", "--lsp" },
						filetypes = { "ruby" },
						root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
					},
				}

				-- https://github.com/ms-jpq/coq_nvim#lsp
				local coq = require("coq")

				for _, lspname in ipairs({
					"kotlin_language_server",
					"sumneko_lua",
					"null-ls",
					"pyright",
					"rust_analyzer",
					"texlab",
					"tsserver",
					"vimls",
					"solargraph",
					"sorbet",
					"sqls",
					"tailwindcss",
				}) do
					local config = lsp_specific_configs[lspname]
					if config ~= nil then
						config = vim.tbl_extend("force", common_config, config)
					else
						config = common_config
					end

					lspconfig[lspname].setup(coq.lsp_ensure_capabilities(config))
				end
			end,
		})

		-- TODO: Setup inlay hints for rust, or just fix rust-tools.nvim's inlay hints
		use({ "nvim-lua/lsp_extensions.nvim", ft = { "rust" } })

		use({
			"kosayoda/nvim-lightbulb",
			after = { "neovim/nvim-lspconfig" },
			config = function()
				require("nvim-lightbulb").update_lightbulb({
					sign = {
						enabled = true,
						priority = -10,
					},
				})

				vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]])
			end,
		})

		-- Provides type annotations for neovim's Lua interface. Needs Sumenkos' Lua LSP. TODO: Not actually set up yet: https://github.com/folke/lua-dev.nvim#%EF%B8%8F--configuration
		use({ "folke/lua-dev.nvim", ft = { "lua" } })

		-- Show func signatures automatically. some filetypes cause issues.
		use({
			"ray-x/lsp_signature.nvim",
			ft = remove_value(lsp_enabled_filetypes, "typescriptreact"),
			after = { "neovim/nvim-lspconfig" },
		})

		-- Super fast, super feature complete, completion plugin
		use({
			"~/git/coq_nvim",
			config = function()
				vim.g.coq_settings = {
					keymap = {
						recommended = false,
						jump_to_mark = "<C-g>", -- <c-h> conflicts with my binding for :TmuxNavigateLeft
						eval_snips = "<leader>cr",
						pre_select = true, -- Don't set the noselect option in completeopt (which would mean that the first item is selcted by default out of the autocomplete options)
					},
					auto_start = "shut-up",
					clients = {
						tmux = {
							enabled = false,
						},
						buffers = {
							enabled = true,
							weight_adjust = -1.9,
						},
						tree_sitter = {
							enabled = true,
							weight_adjust = -1.8,
						},
						lsp = {
							enabled = true,
							weight_adjust = 1.0,
							resolve_timeout = 0.4, -- typescript-language-server doesn't autoimoprt without increasing this val from the default of 0.09. (https://github.com/ms-jpq/coq_nvim/issues/71#issuecomment-902946727)
						},
						snippets = {
							enabled = true,
							weight_adjust = 1.9,
						},
					},
				}

				vim.opt.showmode = false
				vim.opt.shortmess = vim.opt.shortmess + { c = true }

				-- Aint nobody got time to figure out the nuances of doing a keybind
				-- with native lua with expr=true
				vim.api.nvim_exec(
					[[
inoremap <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
inoremap <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
inoremap <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
inoremap <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
inoremap <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"
]],
					false
				)
			end,
		})

		-- Symbol tree. Better than symbols-outline.nvim because it allows filtering by symbol type.
		use({
			"stevearc/aerial.nvim",
			after = { "neovim/nvim-lspconfig" },
			config = function()
				local aerial = require("aerial")

				local custom_attach = function(client)
					aerial.on_attach(client)
					-- Toggle the aerial window with <leader>a
					vim.api.nvim_buf_set_keymap(0, "n", "<leader>a", "<cmd>AerialToggle!<CR>", {})
					-- Jump forwards/backwards with '{' and '}'
					vim.api.nvim_buf_set_keymap(0, "n", "{", "<cmd>AerialPrev<CR>", {})
					vim.api.nvim_buf_set_keymap(0, "n", "}", "<cmd>AerialNext<CR>", {})
					-- Jump up the tree with '[[' or ']]'
					vim.api.nvim_buf_set_keymap(0, "n", "[[", "<cmd>AerialPrevUp<CR>", {})
					vim.api.nvim_buf_set_keymap(0, "n", "]]", "<cmd>AerialNextUp<CR>", {})
					vim.api.nvim_set_keymap("n", "<leader>ls", "<cmd>Telescope aerial<CR>", { noremap = true })
				end

				table.insert(_G.lsp_config_on_attach_callbacks, custom_attach)
			end,
		})

		-- Tree sitter

		-- The package, the pyth, the pegend.
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",

			config = function()
				local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername
				-- use tsserver for
				ft_to_parser.jsx = "tsx"
				ft_to_parser.javascriptreact = "tsx"
				ft_to_parser.typescriptreact = "tsx"
				ft_to_parser.tex = "latex"

				-- Various Treesitter modules config
				local highlight = {
					enable = true,
					disable = { "markdown", "org" }, -- Markdown is slow (I think), and org is experimental.
					-- additional_vim_regex_highlighting = { "org" }, -- Required since TS highlighter doesn't support all syntax features (conceal)
				}
				local indent = {
					enable = false,
				}
				-- requires https://github.com/nvim-treesitter/nvim-treesitter-refactor
				local refactor = {
					highlight_definitions = { enable = true },
					--highlight_current_scope = { enable = true },
				}
				-- requires https://github.com/nvim-treesitter/nvim-treesitter-textobjects ( or some
				-- link like that)
				local textobjects = {
					select = {
						enable = true,
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["a{"] = "@class.outer",
							["i{"] = "@class.inner",
							["ak"] = "@comment.outer",
							["ib"] = "@block.inner",
							["ab"] = "@block.outer",
							["ic"] = "@call.inner",
							["ac"] = "@call.outer",
							["ii"] = "@conditional.inner", -- i for *i*f statement
							["ai"] = "@conditional.outer",
							["il"] = "@loop.inner",
							["al"] = "@loop.outer",
							["ip"] = "@parameter.inner",
							["ap"] = "@parameter.outer",
							["is"] = "@scopename.inner",
							["at"] = "@statement.outer",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						-- disabled ]t, ]T, etc because we want to use it for vim-test/vim-ultest
						goto_next_start = {
							["]f"] = "@function.outer",
							["]{"] = "@class.outer",
							["]k"] = "@comment.outer",
							["]b"] = "@block.outer",
							["]c"] = "@call.outer",
							["]i"] = "@conditional.outer",
							["]l"] = "@loop.outer",
							["]p"] = "@parameter.outer",
						},
						goto_next_end = { -- Note that @class.outer is missing
							["]F"] = "@function.outer",
							["]}"] = "@class.outer",
							["]K"] = "@comment.outer",
							["]B"] = "@block.outer",
							["]C"] = "@call.outer",
							["]I"] = "@conditional.outer",
							["]L"] = "@loop.outer",
							["]P"] = "@parameter.outer",
							-- ["]T"] = "@statement.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[{"] = "@class.outer",
							["[k"] = "@comment.outer",
							["[b"] = "@block.outer",
							["[c"] = "@call.outer",
							["[i"] = "@conditional.outer",
							["[l"] = "@loop.outer",
							["[p"] = "@parameter.outer",
							-- ["[t"] = "@statement.outer",
						},
						goto_previous_end = { -- Note that @class.outer is missing
							["[F"] = "@function.outer",
							["[}"] = "@class.outer",
							["[K"] = "@comment.outer",
							["[B"] = "@block.outer",
							["[C"] = "@call.outer",
							["[I"] = "@conditional.outer",
							["[L"] = "@loop.outer",
							["[P"] = "@parameter.outer",
							--["[T"] = "@statement.outer",
						},
					},
					lsp_interop = {
						enable = true,
						border = "none",
						peek_definition_code = {
							["<leader>ld"] = "@function.outer",
							["<leader>lD"] = "@class.outer",
						},
					},
				}

				local autotag = {
					enable = true,
				}

				local incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<CR>",
						node_incremental = "<CR>",
						scope_incremental = "<CR>",
						node_decremental = "g<CR>",
					},
				}

				local matchup = { -- vim-matchup experimental support for treesitter
					enable = true,
				}

				require("nvim-treesitter.configs").setup({
					highlight = highlight,
					indent = indent,
					refactor = refactor,
					textobjects = textobjects,
					autotag = autotag,
					incremental_selection = incremental_selection,
					matchup = matchup,
				})

				vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			end,
		})

		-- Text objects based on syntax trees!!
		use("nvim-treesitter/nvim-treesitter-textobjects")

		-- Highlight definition of current symbol, current scope
		use("nvim-treesitter/nvim-treesitter-refactor")

		-- Disabled because it's erroring out on ruby
		-- use 'romgrk/nvim-treesitter-context' -- Show "code breadcrumbs"
		use({
			"SmiteshP/nvim-gps",
			requires = "nvim-treesitter/nvim-treesitter",
			config = function()
				require("nvim-gps").setup()
			end,
		}) -- Shows syntactical context in status bar.

		-- Debugging/REPLs
		use({
			"~/git/nvim-dap",
			ft = dap_enabled_filetypes,
			as = "nvim-dap",
			config = function()
				local dap = require("dap")
				local buf_mapfunc = require("std2").buf_mapfunc
				dap.set_log_level("TRACE")

				dap.defaults.fallback.terminal_win_cmd = "10split new"

				-- Rust/C/C++
				dap.adapters.lldb = {
					type = "executable",
					command = "lldb-vscode-11", -- adjust as needed
					name = "lldb",
				}

				dap.configurations.rust = {
					{
						name = "Launch",
						type = "lldb",
						request = "launch",
						program = function()
							local cwd = vim.fn.getcwd()
							local beg, end_ = vim.regex("[^/]*$"):match_str(cwd)
							local exec_name = cwd:sub(beg, end_) -- Aint nobody got time to parse Cargo.toml.
							return cwd .. "/target/debug/" .. exec_name
						end,
						cwd = "${workspaceFolder}",
						stopOnEntry = false,
						args = {},
						runInTerminal = false,
					},
				}

				--- Rails
				dap.adapters.ruby = {
					type = "executable",
					command = "bundle",
					args = { "exec", "readapt", "stdio" },
				}

				dap.configurations.ruby = {
					{
						type = "ruby",
						request = "launch",
						name = "Rails",
						program = "bundle",
						programArgs = { "exec", "rails", "s" },
						useBundler = true,
					},
				}

				-- Python
				dap.adapters.python = {
					type = "executable",
					command = vim.g.python3_host_prog,
					args = { "-m", "debugpy.adapter" },
				}

				dap.configurations.python = {
					{
						type = "python",
						request = "launch",
						justMyCode = false,
						name = "Launch file",
						program = function()
							return vim.fn.expand("%")
						end,
						pythonPath = function()
							-- python3_host_prog is set in init.nvim
							return vim.g.python3_host_prog
						end,
					},
				}

				_G.djangoDapConfig = {
					type = "python",
					request = "launch",
					name = "Django application",
					program = "${workspaceFolder}/manage.py",
					args = { "runserver", "--noreload" },
					-- console = "integratedTerminal";
					django = true,
					autoReload = {
						enable = true,
					},
					pythonPath = function()
						return vim.g.python3_host_prog
					end,
				}

				-- Run django: manage.py test
				_G.djangoTestDapConfig = {
					type = "python",
					request = "launch",
					name = "Django tests",
					program = "${workspaceFolder}/manage.py",
					args = { "test", "--keepdb" },
					-- console = "integratedTerminal";
					autoReload = {
						enable = false,
					},
					pythonPath = function()
						return vim.g.python3_host_prog
					end,
				}

				local mapfunc = require("std2").mapfunc

				mapfunc("n", "<leader>dja", function()
					require("dap").run(_G.djangoDapConfig)
				end, {}, "Debug django application")
				mapfunc("n", "<leader>djt", function()
					require("dap").run(_G.djangoTestDapConfig)
				end, {}, "Debug django tests")
				mapfunc("n", "<leader>dc", function()
					require("dap").continue()
				end, { silent = true }, "continue debugging")
				mapfunc("n", "<leader>dh", function()
					require("dap.ui.widgets").hover()
				end, { silent = true }, "hover info from DAP")
				mapfunc("v", "<leader>dh", function()
					require("dap.ui.widgets").hover()
				end, { silent = true }, "hover info from DAP")
				buf_mapfunc("n", "<leader>dd", function()
					dap.close()
					dap.disconnect()
					require("dapui").close()
				end, { silent = true }, "stop debugging")
				mapfunc("n", "<leader>dp", function()
					require("dap").pause()
				end, { silent = true }, "pause debugging")
				mapfunc("n", "<leader>du", function()
					require("dap").up()
				end, { silent = true }, "go up in stack frame without stepping")
				mapfunc("n", "<leader>dl", function()
					require("dap").up()
				end, { silent = true }, "go lower (down) in stack frame without stepping")
				mapfunc("n", "<leader>d.", function()
					require("dap").up()
				end, { silent = true }, "run until cursor")
				mapfunc("n", "<leader>dv", function()
					require("dap").step_over()
				end, { silent = true }, "step over debugger")
				mapfunc("n", "<leader>di", function()
					require("dap").step_into()
				end, { silent = true }, "step into debugger")
				mapfunc("n", "<leader>do", function()
					require("dap").step_out()
				end, { silent = true }, "step out debugger")
				mapfunc("n", "<leader>db", function()
					require("dap").toggle_breakpoint()
				end, { silent = true }, "toggle breakpoint")
				mapfunc("n", "<leader>dB", function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end, {
					silent = true,
				}, "set conditional breakpoint")
				mapfunc("n", "<leader>dr", function()
					require("dap").repl.open()
				end, { silent = true }, "toggle debugger repl")

				mapfunc("v", "<leader>dr", function()
					require("dap.repl").evaluate(require("std2").get_visual_selection_text(0))
				end, {
					silent = true,
				}, "run visual text in debugger repl")
			end,
		})

		use({
			"rcarriga/nvim-dap-ui",
			after = { "nvim-dap" },
			config = function()
				local dap = require("dap")
				local dapui = require("dapui")

				dapui.setup({
					icons = { expanded = "▾", collapsed = "▸" },
					mappings = {
						-- Use a table to apply multiple mappings
						expand = { "<CR>", "<2-LeftMouse>" },
						open = "o",
						remove = "d",
						edit = "e",
						repl = "r",
					},
					sidebar = {
						-- You can change the order of elements in the sidebar
						elements = {
							-- Provide as ID strings or tables with "id" and "size" keys
							{
								id = "scopes",
								size = 0.33, -- Can be float or integer > 1
							},
							{ id = "breakpoints", size = 0.33 },
							-- { id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.33 },
						},
						size = 10,
						position = "left", -- Can be "left" or "right"
					},
					tray = {
						elements = { "repl" },
						size = 10,
						position = "bottom", -- Can be "bottom" or "top"
					},
					floating = {
						max_height = nil, -- These can be integers or a float between 0 and 1.
						max_width = nil, -- Floats will be treated as percentage of your screen.
						mappings = {
							close = { "q", "<Esc>" },
						},
					},
					windows = { indent = 1 },
				})

				-- Auto start when DAP is started
				dap.listeners.after.event_initialized["dapui_config"] = function()
					dapui.open()
				end
				-- dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
				-- dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

				vim.api.nvim_set_keymap("n", "<leader>de", '<cmd>lua require("dapui").eval()<CR>', {})
				vim.api.nvim_set_keymap("v", "<leader>de", '<cmd>lua require("dapui").eval()<CR>', {})
			end,
		})

		-- use({
		-- 	"theHamsta/nvim-dap-virtual-text",
		-- 	ft = dap_enabled_filetypes,
		-- 	requires = "mfussenegger/nvim-dap",
		-- 	config = function()
		-- 		require("nvim-dap-virtual-text").setup({})
		-- 	end,
		-- })

		-- Spin up a repl in a neovim terminal and send text to it
		use({
			"hkupty/iron.nvim",
			ft = { "python", "ruby" },
			setup = function()
				-- Disable default mappings
				vim.g.iron_map_defaults = true
			end,
			config = function()
				local iron = require("iron")

				-- The function is called `t` for `termcodes`.
				-- You don't have to call it that, but I find the terseness convenient
				local function t(str)
					-- Adjust boolean arguments as needed
					return vim.api.nvim_replace_termcodes(str, true, true, true)
				end

				iron.core.add_repl_definitions({
					python = {
						-- ptpython = {
						--   command = {"ptpython"},
						--   -- You know where I found out how to pass ANSI control sequences like below to
						--   -- neovim's terminal?
						--   -- On a reply, to a comment, on a PR: https://github.com/neovim/neovim/pull/12080#discussion_r546579388
						--   -- Also, the <esc>i is because PtPython has it's own vim mode that I use.
						--   -- The ANSI control sequence is bracketed paste mode.
						--   open = t("<esc>i\x1b[200~"),
						--   close = t("\x1b[201~")
						-- },
						-- ptpython = {
						--   command = {"python", "manage.py", "shell_plus", "--ptpython"},
						--   -- You know where I found out how to pass ANSI control sequences like below to
						--   -- neovim's terminal?
						--   -- On a reply, to a comment, on a PR: https://github.com/neovim/neovim/pull/12080#discussion_r546579388
						--   -- Also, the <esc>i is because PtPython has it's own vim mode that I use.
						--   -- The ANSI control sequence is bracketed paste mode.
						--   open = t("<esc>i\x1b[200~"),
						--   close = t("\x1b[201~")
						-- },
						django_ptpython = {
							command = { "python", "manage.py", "shell_plus", "--ptpython" },
							-- You know where I found out how to pass ANSI control sequences like below to
							-- neovim's terminal?
							-- On a reply, to a comment, on a PR: https://github.com/neovim/neovim/pull/12080#discussion_r546579388
							open = t("\x1b[200~"),
							close = t("\x1b[201~"),
						},
					},
				})

				iron.core.add_repl_definitions({
					sql = {
						pgcli = {
							command = { "pgcli", "-u", "terra" },
							-- You know where I found out how to pass ANSI control sequences like below to
							-- neovim's terminal?
							-- On a reply, to a comment, on a PR: https://github.com/neovim/neovim/pull/12080#discussion_r546579388
							-- Also, the <esc>i is because PtPython has it's own vim mode that I use.
							-- The ANSI control sequence is bracketed paste mode.
							open = t("<esc>i\x1b[200~"),
							close = t("\x1b[201~"),
						},
					},
					ruby = {
						rails = {
							command = { "bundle", "exec", "rails", "console" },
							-- You know where I found out how to pass ANSI control sequences like below to
							-- neovim's terminal?
							-- On a reply, to a comment, on a PR: https://github.com/neovim/neovim/pull/12080#discussion_r546579388
							-- Also, the <esc>i is because PtPython has it's own vim mode that I use.
							-- The ANSI control sequence is bracketed paste mode.
							open = t("<esc>i\x1b[200~"),
							close = t("\x1b[201~"),
						},
					},
				})

				iron.core.set_config({
					preferred = {
						python = "ptpython",
						ruby = "rails",
					},
					repl_open_cmd = "vertical vsplit new",
					visibility = "focus",
				})

				vim.api.nvim_set_keymap("n", "<leader>ro", ":IronRepl<CR>", {})
				vim.api.nvim_set_keymap("n", "<leader>r", "<Plug>(iron-send-motion)", {})
				vim.api.nvim_set_keymap("n", "<leader>rr", "<Plug>(iron-send-lines)", {})
				vim.api.nvim_set_keymap("v", "<leader>r", "<Plug>(iron-visual-send)", {})
				vim.api.nvim_set_keymap("n", "<leader>rc", "<Plug>(iron-interrupt)", {})
				vim.api.nvim_set_keymap("n", "<leader>rl", "<Plug>(iron-clear)", {})
				vim.api.nvim_set_keymap(
					"n",
					"<leader>re",
					'<Cmd>lua require("iron").core.send(vim.api.nvim_buf_get_option(0,"ft"), vim.api.nvim_buf_get_lines(0, 0, -1, false))<CR>',
					{}
				)
			end,
		})

		-- Sessions, I really need'em
		use({
			"rmagatti/auto-session",
			config = function()
				require("auto-session").setup({
					log_level = "info",
					auto_save_enabled = true,
					auto_restore_enabled = true,
				})
			end,
		})

		-- The unofficial standard library for neovim plugins.
		use("nvim-lua/plenary.nvim")

		-- Turn good ol' linters and formatters to an LSP.
		use({
			"jose-elias-alvarez/null-ls.nvim",
			requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },

			config = function()
				require("null-ls").setup({
					debug = true,
					sources = {
						require("null-ls").builtins.formatting.stylua,
						require("null-ls").builtins.formatting.black,
						require("null-ls").builtins.formatting.prettier,
						require("null-ls").builtins.diagnostics.eslint,
					},
				})
			end,
		})

		-- (Fuzzy) search everything!
		use({
			"nvim-telescope/telescope.nvim",
			config = function()
				local telescope = require("telescope")
				telescope.setup({
					defaults = {
						layout_strategy = "vertical",
						layout_config = {
							height = 0.99,
							width = 0.99, -- Works better because usually my terminal takes only half my screen
							preview_height = 0.6,
						},
					},
					pickers = {
						buffers = {
							mappings = {
								i = {
									["<c-d>"] = "delete_buffer",
								},
								n = {
									["<c-d>"] = "delete_buffer",
								},
							},
						},
					},
					extensions = {
						fzf = {
							fuzzy = true, -- false will only do exact matching
							override_generic_sorter = true, -- override the generic sorter
							override_file_sorter = true, -- override the file sorter
						},

						file_browser = { -- Requires the telescope-file-browser
							mappings = {
								["i"] = {
									["<C-b>"] = function(prompt_bufnr)
										print(require("telescope").extensions)
										require("telescope").extensions.file_browser.actions.goto_parent_dir(
											prompt_bufnr,
											true
										)
									end,
								},
								["n"] = {
									["-"] = function(prompt_bufnr)
										print(require("telescope").extensions)
										require("telescope").extensions.file_browser.actions.goto_parent_dir(
											prompt_bufnr,
											true
										)
									end,
								},
							},
						},
					},
				})
				-- Mappings
				local mapping_opts = { noremap = true }
				local mapfunc = require("std2").mapfunc
				local buf_mapfunc = require("std2").buf_mapfunc

				local builtin = require("telescope.builtin")
				mapfunc("n", "<leader>fw", builtin.grep_string, { noremap = true }, "grep_string")
				mapfunc("n", "<leader>ff", builtin.fd, { noremap = true }, "fd")
				mapfunc("n", "<leader>fcf", function()
					builtin.fd({ search_dirs = { vim.fn.expand("%:p:h") } })
				end, {
					noremap = true,
				}, "fd in cur dir")
				mapfunc("n", "<leader>fcg", function()
					builtin.live_grep({ search_dirs = { vim.fn.expand("%:p:h") } })
				end, {
					noremap = true,
				}, "live_grep in cur dir")
				mapfunc("n", "<leader>fg", builtin.live_grep, { noremap = true }, "live_grep")
				-- Isn't prefixed with f cuz it's so commonly used
				mapfunc("n", "<leader>b", builtin.buffers, { noremap = true }, "buffers")
				-- Isn't prefixed with f cuz it's so commonly used
				mapfunc("n", "<leader>h", builtin.oldfiles, { noremap = true }, "oldfiles")
				mapfunc("n", "<leader>ft", builtin.help_tags, { noremap = true }, "help_tags")
				mapfunc("n", "<leader>f:", builtin.command_history, { noremap = true }, "command_history")
				mapfunc(
					"n",
					"<leader>f/",
					builtin.current_buffer_fuzzy_find,
					{ noremap = true },
					"current_buffer_fuzzy_find"
				)
				mapfunc("n", "<leader>fj", builtin.jumplist, { noremap = true }, "jumplist")
				mapfunc("n", "<leader>f.", builtin.resume, { noremap = true }, "resume")
				mapfunc("n", ",-", function()
					require("telescope").extensions.file_browser.file_browser({ path = vim.fn.expand("%:p:h") })
				end, {}, "file_browser cur dir")
				mapfunc("n", "-", function()
					require("telescope").extensions.file_browser.file_browser()
				end, {}, "file_browser")

				local function on_attach()
					buf_mapfunc("n", "<leader>la", builtin.lsp_code_actions, mapping_opts)

					buf_mapfunc("n", "gd", function()
						builtin.lsp_definitions({ jump_type = "jump" })
					end, mapping_opts)

					-- Open definition in horizontal splits with gsd
					buf_mapfunc("n", "gsd", function()
						builtin.lsp_definitions({ jump_type = "split" })
					end, mapping_opts)

					-- Open definition in vertical splits with gad.
					buf_mapfunc("n", "gad", function()
						builtin.lsp_definitions({ jump_type = "vsplit" })
					end, mapping_opts)

					-- Repeat the same story with splits and going to references as with splits and going to definitions above.
					buf_mapfunc("n", "gr", function()
						builtin.lsp_references({ jump_type = "jump" })
					end, mapping_opts)
					buf_mapfunc("n", "gsr", function()
						builtin.lsp_references({ jump_type = "split" })
					end, mapping_opts)
					buf_mapfunc("n", "gar", function()
						builtin.lsp_references({ jump_type = "jump" })
					end, mapping_opts)

					buf_mapfunc("n", "<leader>li", builtin.lsp_implementations, mapping_opts)
					buf_mapfunc("n", "<leader>le", builtin.lsp_workspace_diagnostics, mapping_opts)
				end

				table.insert(_G.lsp_config_on_attach_callbacks, on_attach)
			end,
		})

		-- Git and Github
		-- Look at lines added/modified/taken away, all at a glance.
		use({
			"lewis6991/gitsigns.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("gitsigns").setup({

					keymaps = {
						noremap = true,

						["n ]h"] = {
							expr = true,
							"&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'",
						},
						["n [h"] = {
							expr = true,
							"&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'",
						},

						["n <leader>gw"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
						["v <leader>gw"] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
						["n <leader>gu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
						["n <leader>gr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
						["v <leader>gr"] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
						["n <leader>gp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
						["n <leader>gb"] = '<cmd>lua require"gitsigns".blame_line()<CR>',
						["n <leader>gW"] = '<cmd>lua require"gitsigns".stage_buffer()<CR>',

						-- Text objects
						["o ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
						["x ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
					},
				})
			end,
		})

		-- And I quote tpope, "A git plugin so awesome, it should be illegal."
		use({ "tpope/vim-fugitive", requires = { "nvim-lua/plenary.nvim" } })

		vim.api.nvim_set_keymap("n", "<leader>gg", ":DiffviewOpen<CR>", {})

		-- Better diff view
		use({
			"sindrets/diffview.nvim",
			requires = "nvim-lua/plenary.nvim",
			cmd = { "DiffviewOpen", "DiffviewFileHistory" },
		})

		-- Basically use it only for :GBrowse
		use({ "tpope/vim-rhubarb", requires = { "tpope/vim-fugitive" }, cmd = { "GBrowse" } })

		-- Who needs web interfaces when you have neovim interfaces (for Github)?
		use({
			"pwntester/octo.nvim",
			requires = { "kyazdani42/nvim-web-devicons" },
		})

		-- Misc
		use("tpope/vim-commentary") -- (Un)comment stuff with gc
		use({
			"folke/which-key.nvim",
			config = function()
				require("which-key").setup({
					layout = {
						height = { min = 4, max = 200 },
						width = { min = 20, max = 200 }, -- min and max width of the columns
					},
				})
			end,
		}) -- show candidate mappings after pressing a key

		-- A quick-and-dirty solution to typing Amharic in vim,
		-- without having to rely on changing the system-wide keyboard layout
		use({ "davidatbu/amharic.nvim", cmd = { "AmharicToggle" }, ft = { "markdown" } })
		-- Kotlin
		use({ "udalov/kotlin-vim", ft = { "kotlin" } })
		-- JSX
		-- CSS / web dev
		-- use("maxmellon/vim-jsx-pretty") -- I hope this fixes indentation for jSX until TreeSitter supports JSX.
		use({ "windwp/nvim-ts-autotag", ft = { "typescriptreact", "javascriptreact", "html" } }) -- When changing tags, change both
		use({
			"crivotz/nvim-colorizer.lua",
			ft = { "typescriptreact", "css", "javascriptreact" },

			-- If you're reading this in a CSS file, #0ED should be highlighted with light blue. Thank you nvim-colorizer.
			config = function()
				require("colorizer").setup()
			end,
		})

		-- Markdown
		use({ "plasticboy/vim-markdown", ft = { "markdown" } })
		use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", ft = { "markdown" } })
		use({ "dhruvasagar/vim-table-mode", ft = { "markdown" } })

		-- Testing things
		use({ "tpope/vim-dispatch", opt = true, cmd = { "Dispatch", "Make", "Focus", "Start" } })

		-- FYI, dispatch.vim is not a strict requirement, but it's nicer.
		use({
			"vim-test/vim-test",
			requires = { "tpope/vim-dispatch" },
			ft = { "ruby" },
			config = function()
				vim.g["test#strategy"] = "dispatch"
				vim.g["test#ruby#rspec#executable"] = "bundle exec rspec"
				-- vim.g["test#ruby#rspec#options"] = "--force-color"
			end,
		})

		-- Let's see how much better this is.
		use({
			"rcarriga/vim-ultest",
			requires = { "vim-test/vim-test" },
			run = ":UpdateRemotePlugins",
			ft = { "ruby" },
			setup = function()
				vim.g.ultest_running_sign = "🟡"
				-- vim.g.ultest_icons = 0
				-- (From README) easy way to trick unittest/rspec/testing frameworks into outputting color.
				vim.g.ultest_use_pty = 1
			end,
			config = function()
				-- The default icons there.

				-- Aint spending another minute this week editing my .dotfiles, including
				-- standardizing the two ways of mapping things below.
				vim.api.nvim_set_keymap("n", "<leader>tsn", "<Plug>(ultest-stop-nearest)", {})
				vim.api.nvim_set_keymap("n", "<leader>tsf", "<Plug>(ultest-stop-file)", {})
				vim.api.nvim_set_keymap("n", "<leader>ta", "<Plug>(ultest-attach)", {})
				vim.api.nvim_set_keymap("n", "<leader>to", "<Plug>(ultest-output-jump)", {})
				vim.api.nvim_set_keymap("n", "]t", "<Plug>(ultest-next-fail)", {})
				vim.api.nvim_set_keymap("n", "[t", "<Plug>(ultest-prev-fail)", {})
				vim.api.nvim_set_keymap("n", "<leader>tf", "<Plug>(ultest-run-file)", {})
				vim.api.nvim_set_keymap("n", "<leader>tn", "<Plug>(ultest-run-nearest)", {})
				vim.api.nvim_set_keymap("n", "<leader>tl", "<Plug>(ultest-run-last)", {})

				--- Integrate vim-ultest with nvim-dap
				-- https://github.com/rcarriga/vim-ultest/blob/0aa467db97a075c576e97424865a57a457fd4851/doc/ultest.txt#L345-L379
				local rspec_dap_builder = function(cmd)
					local programArgs = vim.list_slice(cmd, 2) -- Python version is cmd[1:]
					local configuration = {
						dap = {
							type = "ruby",
							request = "launch",
							name = "Debugged Rspec",
							program = "bundle",
							programArgs = programArgs,
							useBundler = false,
						},
					}
					print(vim.inspect(configuration))
					return configuration
				end

				require("ultest").setup({
					builders = {
						["ruby#rspec"] = rspec_dap_builder,
					},
				})
			end,
		})

		-- Improved definition of the "word" text object.
		use("chaoren/vim-wordmotion")

		-- Tex
		--use { 'lervag/vimtex',  ft = { 'tex' } }

		-- Colors and other niceties
		use({
			"folke/zen-mode.nvim",
			branch = "main",
			module = { "zen-mode" },
			config = function()
				require("zen-mode").setup({})
			end,
		})
		mapfunc("n", "<leader>v", function()
			require("zen-mode").toggle()
		end, {}, "toggle zen-mode")

		use({
			"kyazdani42/nvim-web-devicons",
			config = function()
				require("nvim-web-devicons").setup({})
			end,
		})
		-- use("folke/tokyonight.nvim") -- colorscheme
		-- use("joshdick/onedark.vim") -- colorscheme
		-- use 'tjdevries/colorbuddy.nvim'
		use("Mofiqul/vscode.nvim")
		use({
			"nvim-lualine/lualine.nvim",
			requires = { "kyazdani42/nvim-web-devicons" },
			config = function()
				require("lualine").setup()
			end,
		})

		-- use( { 'bbenzikry/snazzybuddy.nvim', requires = "tjdevries/snazzybuddy.nvim" } )

		-- Capture output of ex commands (slightly quicker than doing :redir /tmp/SOMEFILE | the_ex_command | redir END)
		use({ "tyru/capture.vim", cmd = "Capture" })

		-- A sidebar.
		use({
			"sidebar-nvim/sidebar.nvim",
			module = { "sidebar-nvim" },
			config = function()
				local sidebar = require("sidebar-nvim")
				local opts = {
					open = true,
					initial_width = 35,
					sections = { "diagnostics", "git" },
					files = {
						icon = "",
						show_hidden = false,
						ignored_paths = { "%.git$" },
					},
				}
				sidebar.setup(opts)
			end,
		})
		mapfunc("n", "<leader>s", function()
			require("sidebar-nvim").toggle()
		end, {}, "toggle sidebar.nvim")

		-- A "buffer" line. (like tabs, but buffers, and on top)
		use({
			"akinsho/bufferline.nvim",
			requires = "kyazdani42/nvim-web-devicons",
			config = function()
				require("bufferline").setup({})
			end,
		})

		-- Clipboard manager.
		use({
			"AckslD/nvim-neoclip.lua",
			requires = {
				{ "tami5/sqlite.lua", module = "sqlite" },
				-- you'll need at least one of these
				{ "nvim-telescope/telescope.nvim" },
				-- {'ibhagwan/fzf-lua'},
			},
			config = function()
				require("neoclip").setup()
				require("telescope").load_extension("neoclip")
			end,
		})

		-- Telescope file browser.
		use({
			"nvim-telescope/telescope-file-browser.nvim",
			config = function()
				require("telescope").load_extension("file_browser")
			end,
		})

		-- Indicate LSP progress
		use({
			"j-hui/fidget.nvim",
			after = { "neovim/nvim-lspconfig" },
			config = function()
				require("fidget").setup({})
			end,
		})

		-- vim-matchup
		use({ "andymass/vim-matchup", ft = { "ruby" } })

		--
		use({
			"nvim-telescope/telescope-fzf-native.nvim",
			run = "make",
			config = function()
				require("telescope").load_extension("fzf")
			end,
		})
	end,

	config = {
		git = {
			clone_timeout = 1800, -- 30 minutes
		},
	},
})

-- At end of quickstart section, https://github.com/wbthomason/packer.nvim#quickstart one finds
-- this snippet, because running PackerCompile is needed to "refresh" configuration for Packer.
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> |  PackerCompile
  augroup end
]])
