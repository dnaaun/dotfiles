---@diagnostic disable: unused-local
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

--- Escapes curly braces so that luasnip doesn't try to do
--- variable/node interpolation on them.
---@param txt string
---@return string
local function escape_curly_braces(txt)
	return txt:gsub("{", "{{"):gsub("}", "}}")
end

return {
	s(
		{ trig = "two_col_notes", descr = "two column notes structure" },
		fmt(escape_curly_braces([[
\documentclass{article}
\usepackage{geometry}
\usepackage{paracol}
\geometry{a4paper,left=0.2in,top=0.2in,right=0.2in,bottom=0.3in}
\begin{document}
\columnratio{0.6}
\begin{sloppypar}
  \begin{paracol}{2}
    \begin{leftcolumn}
      ]]) .. "{}" .. escape_curly_braces([[

    \end{leftcolumn}
  \end{paracol}
\end{sloppypar}
\end{document}
      ]]), {
			i(1, ""),
		})
	),
}
