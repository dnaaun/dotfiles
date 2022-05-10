return {
	"L3MON4D3/LuaSnip",
	config = function()
		local ls = require("luasnip")

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

		-- Make the snippets a bit more ergonomic to write
		local fmt = require("luasnip.extras.fmt").fmt

		local same = function(index)
			return f(function(arg)
				print(vim.inspect(arg))
				return ""
			end, { index })
		end

		--- Used for useState() so far
		--- @param str string
		local function first_to_upper(str)
			return (str:gsub("^%l", string.upper))
		end

		ls.add_snippets("typescriptreact", {
			s(
				"us",
				fmt("const [{}, {}] = useState({})", {
					i(1, "name"),
					f(function(arg)
						local state_name = arg[1][1]
						return "set" .. first_to_upper(state_name)
					end, { 1 }),
					i(2),
				})
			),
			s(
				"test",
				f(function()
					return "UMMM"
				end, {})
			),
		})

		ls.snippets = {
			markdown = {
				s(
					"ct",
					f(function()
						return vim.fn.system({ "gdate", "--iso-8601=minutes" })
					end, {})
				),
			},

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
