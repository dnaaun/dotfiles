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
\usepackage{enumitem}
\setlist[itemize]{leftmargin=0.2em, labelsep=0.2em, nolistsep}
\begin{document}
\columnratio{0.25}
\begin{sloppypar}
	\begin{paracol}{2}
		\begin{rightcolumn}
      ]]) .. "{}" .. escape_curly_braces([[

    \end{rightcolumn}
  \end{paracol}
\end{sloppypar}
\end{document}
      ]]), {
			i(1, ""),
		})
	),

	s(
		{ trig = "tn", descr = "take notes (on the left side)" },
		fmt(escape_curly_braces([[
\end{nthcolumn}
\begin{nthcolumn*}{1}
	\footnotesize
	\begin{itemize}
    \item ]]) .. [[{}
]] .. escape_curly_braces([[
  \end{itemize}
\end{nthcolumn*}
\begin{nthcolumn}{2}
  ]]), {
			i(1, ""),
		})
	),

	s(
		{ trig = "bl", descr = "begin list" },
		fmt(escape_curly_braces([[
	\begin{itemize}
    \item ]]) .. [[{}
]] .. escape_curly_braces([[
  \end{itemize}
]]), {
			i(1, ""),
		})
	),

	s(
		{ trig = "l", descr = "list item" },
		fmt("\\item {}", {
			i(1, ""),
		})
	),

	-- put in the \begin{quote} environment whatever is in the clipboard.
	s(
		"cq",
		f(function()
			local to_return = vim.list_extend(
				vim.list_extend({ "\\begin{quote}" }, vim.fn.getreg("0", 1, true)),
				{ "\\end{quote}", "", "" }
			)

			-- Check if current line has any non-space text on it, and add an empty line to the
			-- beginning of the list if it does.
			local line_content = vim.fn.getline(".")
			if vim.fn.matchstr(line_content, "\\S") ~= "" then
				table.insert(to_return, 1, "")
			end
			-- Check if the line above has any text on it, and do the same
			local cur_line = vim.fn.line(".")
			if cur_line > 1 then
				local line_above_content = vim.fn.getline(cur_line - 1)
				if vim.fn.matchstr(line_above_content, "\\S") ~= "" then
					table.insert(to_return, 1, "")
				end
			end

			return to_return
		end, {})
	),
}
