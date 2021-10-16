-- Keybindings
local setup_mappings = function()
	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(0, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.api.nvim_buf_set_keymap(0, "n", "<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(0, "n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	vim.api.nvim_buf_set_keymap(0, "n", "gh", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
	vim.api.nvim_buf_set_keymap(0, "n", "[e", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	vim.api.nvim_buf_set_keymap(0, "n", "]e", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
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
    print("About to format begining at " .. start_line .. "and ending at "..  end_line)
		if start_line >= 0 and end_line >= 0 then
			vim.lsp.buf.range_formatting(opts, { start_line, 0 }, { end_line, 0 })
		end
		return 0
	end

	vim.bo.formatexpr = "v:lua._G.lsp_formatexpr()"
end

-- Allow other files to define callbacks that get called `on_attach`
local on_attach = function(client)
	for _, plugin_custom_attach in pairs(_G.lsp_config_on_attach_callbacks) do
		plugin_custom_attach(client)
	end

	setup_mappings()
	setup_formatexpr(client)
end

-- Config for all LSPs
local common_config = {
	on_attach = on_attach,
}
-- Needed for sumenko
-- local system_name
local system_name
if vim.fn.has("mac") == 1 then
	system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
	system_name = "Linux"
elseif vim.fn.has("win32") == 1 then
	system_name = "Windows"
else
	print("Unsupported system for sumneko")
end
local sumneko_root_path = vim.fn.expand("~") .. "/src/lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/" .. system_name .. "/lua-language-server"

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
	lua = {
		settings = {
			Lua = {
				runtime = {
					-- LuaJIT in the case of Neovim
					version = "LuaJIT",
					path = vim.split(package.path, ";"),
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim", "use" },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					},
				},
			},
		},
	},
	kotlin_language_server = {
		cmd = {
			vim.fn.expand("~") .. "/src/kotlin-language-server/server/build/install/server/bin/kotlin-language-server",
		},
		root_dir = lspconfig.util.root_pattern("settings.gradle.kts") or lspconfig.util.root_pattern("settings.gradle"),
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
					args = { "%l", "%p", "%f" }
				},
				latexFormatter = "latexindent",
				latexindent = {
					modifyLineBreaks = true,
				},
        build = {
          args = { "%f", "--synctex", "--keep-logs", "--keep-intermediates" },
          executable = "tectonic",
          forwardSearchAfter = true,
          onSave = true
        },
			},
		},
	},

	sqlls = {
		cmd = { "sql-language-server", "up", "--method", "stdio" },
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
}

-- https://github.com/ms-jpq/coq_nvim#lsp
local coq = require("coq")
require("plugin_config.null-ls")

for _, lspname in ipairs({
	"pyright",
	"tsserver",
	"cssls",
	"vimls",
	"rust_analyzer",
	"kotlin_language_server",
	"html",
	"sumneko_lua",
	"texlab",
	"null-ls",
  "sqlls"
}) do
	local config = lsp_specific_configs[lspname]
	if config ~= nil then
		config = vim.tbl_extend("force", common_config, config)
	else
		config = common_config
	end

	lspconfig[lspname].setup(coq.lsp_ensure_capabilities(config))
end
