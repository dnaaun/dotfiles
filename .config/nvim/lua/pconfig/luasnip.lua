local config = function()
	local ls = require("luasnip")

	-- Since treehopper.nvim requires that we use `tsx` as a filetype,
	-- and luasnip doesn't work when I just do ls.add_snippets("tsx", ...)
	ls.filetype_extend("typescriptreact", { "typescript" })

	vim.keymap.set({ "v", "i" }, "<C-n>", function()
		if ls.expand_or_locally_jumpable() then
			ls.expand_or_jump()
		end
	end, {})

	ls.config.setup({ update_events = "TextChanged,TextChangedI" })
	-- some shorthands...
	local s = ls.snippet
	local sn = ls.snippet_node
	local t = ls.text_node
	local i = ls.insert_node
	local f = ls.function_node
	local c = ls.choice_node
	local d = ls.dynamic_node
	local r = ls.restore_node
	local l = require("luasnip.extras").lambda
	local rep = require("luasnip.extras").rep
	local p = require("luasnip.extras").partial
	local m = require("luasnip.extras").match
	local n = require("luasnip.extras").nonempty
	local dl = require("luasnip.extras").dynamic_lambda
	local fmt = require("luasnip.extras.fmt").fmt
	local fmta = require("luasnip.extras.fmt").fmta
	local types = require("luasnip.util.types")
	local conds = require("luasnip.extras.expand_conditions")

	-- (At least when reloading this file), snippets get added multipel times
	-- sometimes, so remove all before adding them.
	ls.cleanup()

	-- Load my snipmate style snippets
	require("luasnip.loaders.from_snipmate").load()

	-- Load my lua snippets
	require("luasnip.loaders.from_lua").load()

	-- the snippets are supposed to reload in the session when I edit them, but they don't, soo
	local function setup_luasnippet_reload_on_save()
		local g = vim.api.nvim_create_augroup("ReloadLuaSnip", {})
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			group = g,
			pattern = "*luasnippets/*.lua",
			callback = function(args)
				require("pconfig.luasnip").config()
			end,
		})
	end

	setup_luasnippet_reload_on_save()
end

return {
	"L3MON4D3/LuaSnip",
	config = config,
  event = "InsertEnter"
}
