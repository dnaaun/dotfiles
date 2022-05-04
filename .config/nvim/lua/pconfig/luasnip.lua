return {
	"L3MON4D3/LuaSnip",
	config = function()
		local ls = require("luasnip")
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

		ls.snippets = {
			-- When trying to expand a snippet, luasnip first searches the tables for
			-- each filetype specified in 'filetype' followed by 'all'.
			-- If ie. the filetype is 'lua.c'
			--     - luasnip.lua
			--     - luasnip.c
			--     - luasnip.all
			-- are searched in that order.

			all = {
				s(
					"ct",
					f(function()
						return vim.fn.system({ "gdate", "--iso-8601=minutes" })
					end, {})
				),

				-- put in the \begin{quote} environment whatever is in the clipboard.
				-- Had trouble doing it with a VSCode style snippet, so here goes.
				s(
					"cq",
					f(function()
						return vim.list_extend(
							vim.list_extend({ "\\begin{quote}" }, vim.fn.getreg("+", 1, true)),
							{ "\\end{quote}" }
						)
					end, {})
				),
			},
		}

		-- Load my snipmate style snippets
		require("luasnip.loaders.from_snipmate").load()
	end,
}
