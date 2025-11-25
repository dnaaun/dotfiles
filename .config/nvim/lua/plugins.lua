local plugins = {
	require("pconfig.which_key"), -- show candidate mappings after pressing a key

	require("pconfig.matchup"),


	require("pconfig.tmux"),

	require("pconfig.surround"),

	require("pconfig.zen_mode"),

	require("pconfig.telescope"),
	require("pconfig.telescope_fzf_native"),


	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
}

-- Append to plugins if not in pager mode
plugins_for_non_pager_mode = {
	require("pconfig.cmp"),
	{ "hrsh7th/cmp-nvim-lsp", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	{ "itchyny/vim-qfedit" },
	require("pconfig.treesitter"),
	require("pconfig.treehopper"),
	require("pconfig.telescope_file_browser"),
	require("pconfig.telescope_ast_grep"),
	-- LSP config moved to init.lua since it's not a plugin anymore
	require("pconfig.trouble"),
	require("pconfig.dap"),
	require("pconfig.dap_ui"),
	{ "hrsh7th/cmp-buffer", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	require("pconfig.luasnip"),
	require("pconfig.auto_dark_mode"),
	require("pconfig.terminal"),
	require("pconfig.buffer_sticks"),
	require("pconfig.harpoon"),
	-- require("pconfig.harpoon_lualine"),
	require("pconfig.markdown_preview"),
	-- require("pconfig.tint"), -- maybe makes everything slow?
	-- require("pconfig.origami"),
	-- require("pconfig.profile"),
	require("pconfig.flutter_tools"),
	require("pconfig.highlight_colors"),
	require("pconfig.gh"),
	require("pconfig.octo"),
	require("pconfig.windsurf"),
	require("pconfig.crates"),
	require("pconfig.text_case"),
	require("pconfig.lint"),
	{ "hrsh7th/cmp-path", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	{ "hrsh7th/cmp-cmdline", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	{ "f3fora/cmp-spell", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	require("pconfig.conform"),
	require("pconfig.copilot_cmp"),
	-- { "rcarriga/cmp-dap", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	require("pconfig.gp"),
	require("pconfig.treesitter_context"),
	{ "saadparwaiz1/cmp_luasnip", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	{ "nanotee/sqls.nvim" },
	require("pconfig.web_devicons"),
	require("pconfig.lualine"),
	require("pconfig.fidget"),
	require("pconfig.mini_cursorword"),
	require("pconfig.aerial"),
	require("pconfig.femaco"),
	require("pconfig.otter"),
	require("pconfig.diffview"),
	require("pconfig.amharic"),
	require("pconfig.iron"),
	require("pconfig.neogit"),
	require("pconfig.gitsigns"),
	require("pconfig.gitlinker"),
	{
		"FabijanZulj/blame.nvim",
		opts = {
			blame_options = { "-w" },
		},
	},

	require("pconfig.auto_session"),
	-- Orgmode related
	require("pconfig.orgmode"),
	require("pconfig.telescope_orgmode"),
	require("pconfig.bullets"),
	-- require("pconfig.autolist"),
	require("pconfig.org_bullets"),

	require("pconfig.dressing"),
	require("pconfig.treesitter_unit"),
	--
	-- require("pconfig.dirbuf"),
	require("pconfig.oil"),
	-- require("pconfig.neo_tree"),

	-- require("pconfig.workspace_diagnostics"), -- Slows down pyright a lot

	require("pconfig.difft"),
	require("pconfig.hunks"),
	require("pconfig.jj_diffconflicts"),
	require("pconfig.typescript_tools"),
}

-- Append to plugins if not in pager mode
if not _G.PAGER_MODE then
	vim.list_extend(plugins, plugins_for_non_pager_mode)
end

return plugins
