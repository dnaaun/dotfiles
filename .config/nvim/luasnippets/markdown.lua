local Path = require("plenary.path")

local ls = require("luasnip")
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

-- insert node, but the placeholder string will be split into a list if it contains new
-- lines.
local function insert_node_with_new_lines(first_arg, placeholder)
	if type(placeholder) == "string" and string.find(placeholder, "\n") then
		placeholder = vim.split(placeholder, "\n")
	end
	return i(first_arg, placeholder)
end

return {
	s(
		{ trig = "codeblock", descr = "code block (```)" },
		fmt(
			[[
      ```{}
      {}
      ```
      ]],
			{
				i(1, "ruby"),
				insert_node_with_new_lines(
					2,
					[[
def some_func
end]]
				),
			}
		)
	),
	s(
		{ trig = "l", descr = "[markdown link](http://..(DEFAULTS TO CLIPBOARD)" },
		fmt("[{}]({})", {
			i(1, "link text"),
			f(function()
				return vim.fn.getreg("+", 1, true)
			end, {}),
		})
	),

	-- Written by GPT-4
	s(
		{ trig = "ldate", descr = "Insert current time and date" },
		fmt("{}", {
			f(function()
				return os.date("%x %X")
			end, {}),
		})
	),
}
