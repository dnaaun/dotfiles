local plugins = {
	require("pconfig.which_key"), -- show candidate mappings after pressing a key

	-- require("pconfig.matchup"), -- disabled: major perf bottleneck (see profile.log)

	require("pconfig.tmux"),

	require("pconfig.surround"),

	require("pconfig.zen_mode"),

	require("pconfig.telescope"),
	require("pconfig.telescope_fzf_native"),

	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	require("pconfig.auto_dark_mode"), -- suspicion that this is slowing me down. Not sure tho.
}

-- Append to plugins if not in pager mode
plugins_for_non_pager_mode = {
	require("pconfig.cmp"),
	{ "hrsh7th/cmp-nvim-lsp", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	{ "itchyny/vim-qfedit" },
	require("pconfig.treesitter"),
	require("pconfig.treehopper"),
	require("pconfig.telescope_file_browser"),
	-- require("pconfig.telescope_ast_grep"), -- Don't need it for now.
	-- LSP config moved to init.lua since it's not a plugin anymore
	-- require("pconfig.trouble"), -- don't need it for now.
	-- require("pconfig.dap"), -- don't need it for now.
	-- require("pconfig.dap_ui"), -- don't need it for now.
	{ "hrsh7th/cmp-buffer", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	require("pconfig.luasnip"),
	require("pconfig.terminal"),
	require("pconfig.markdown_preview"), -- not playing nice with lazier.lua right now

	-- require("pconfig.flutter_tools"), -- don't need it for now.
	-- require("pconfig.highlight_colors"), -- don't need it for now.
	-- require("pconfig.gh"), -- don't need it for now.
	-- require("pconfig.octo"), -- slowing startup
	require("pconfig.gh_review"),
	-- require("pconfig.crates"), -- don't need it for now.
	require("pconfig.text_case"),
	require("pconfig.lint"),
	{ "hrsh7th/cmp-path", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	{ "hrsh7th/cmp-cmdline", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	{ "f3fora/cmp-spell", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	require("pconfig.conform"),
	-- { "rcarriga/cmp-dap", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	require("pconfig.treesitter_context"),
	{ "saadparwaiz1/cmp_luasnip", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	-- { "nanotee/sqls.nvim" }, -- don't need it for now.
	require("pconfig.web_devicons"),
	require("pconfig.lualine"),
	require("pconfig.fidget"),
	-- require("pconfig.mini_cursorword"), -- don't need it for now.
	require("pconfig.aerial"),
	-- require("pconfig.femaco"), -- don't need it for now.
	-- require("pconfig.otter"), -- don't need it for now.
	require("pconfig.diffview"),
	require("pconfig.amharic"),
	require("pconfig.iron"),
	require("pconfig.gitsigns"),
	require("pconfig.gitlinker"),
	require("pconfig.auto_session"), -- can't get it to work with lazily.
	-- Orgmode related
	require("pconfig.orgmode"),
	require("pconfig.telescope_orgmode"),
	-- require("pconfig.bullets"),
	-- require("pconfig.autolist"),
	require("pconfig.org_bullets"),

	require("pconfig.dressing"),
	-- require("pconfig.treesitter_unit"), -- don't need it for now.
	--
	-- require("pconfig.dirbuf"),
	require("pconfig.oil"),
	-- require("pconfig.neo_tree"),

	-- require("pconfig.workspace_diagnostics"), -- Slows down pyright a lot

	require("pconfig.hunks"),
	-- require("pconfig.jj_diffconflicts"), -- not using it / it doesn't work.
	require("pconfig.typescript_tools"),

  -- AI coding asistant thingys
	require("pconfig.gp"),

	-- require("pconfig.twilight"), - meh. I often want to read stuff not close by.
}

-- Append to plugins if not in pager mode
if not _G.PAGER_MODE then
	vim.list_extend(plugins, plugins_for_non_pager_mode)
end

return plugins
