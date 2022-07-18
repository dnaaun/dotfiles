-- Non luasnip imports
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

-- Get a list of  the property names given an `interface_declaration`
-- treesitter *tsx* node.
-- Ie, if the treesitter node represents:
--   interface {
--     prop1: string;
--     prop2: number;
--   }
-- Then this function would return `{"prop1", "prop2"}
---@param id_node {} Stands for "interface declaration node"
---@return string[]
local function get_prop_names(id_node)
	local object_type_node = id_node:child(2)
	if object_type_node:type() ~= "object_type" then
		return {}
	end

	local prop_names = {}

	for prop_signature in object_type_node:iter_children() do
		if prop_signature:type() == "property_signature" then
			local prop_iden = prop_signature:child(0)
			local prop_name = vim.treesitter.query.get_node_text(prop_iden, 0)
			prop_names[#prop_names + 1] = prop_name
		end
	end

	return prop_names
end

--- Used for useState() so far
--- @param str string
local function first_to_upper(str)
	return (str:gsub("^%l", string.upper))
end

local function get_probable_react_comp_name()
	local dir_name = vim.fn.expand("%"):match("([^/]+)/[^/]+$")
	local file_name = vim.fn.expand("%:t")

	if vim.fn.match(file_name, "index\\..*tsx\\?") == 0 then
		return dir_name
	else
		return vim.fn.substitute(file_name, "\\..*$", "", "g")
	end
end

return {
	-- Escaping braces makings things look crazy here.
	s(
		{ trig = "f", dscr = "function" },
		fmt(
			[[
function {}({}) {{
  {}
}}
  ]],
			{ i(1, ""), i(2, ""), i(3, "") }
		)
	),

	s(
		{ trig = "um", dscr = "useMemo()" },
		fmt(
			[[
const {} = useMemo(() => {}, [])
  ]],
			{ i(1, ""), i(2, "") }
		)
	),
	s(
		{ trig = "us", dscr = "useState()" },
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
		{ trig = "uc", dscr = "useCallback()" },
		fmt(
			[[
const {} = useCallback(() => {}, [])
  ]],
			{ i(1, ""), i(2, "") }
		)
	),
	s(
		{ trig = "ue", dscr = "useEffect()" },
		fmt(
			[[
useEffect(() => {{
  {}
}}, [{}])
  ]],
			{ i(1, ""), i(2, "") }
		)
	),

	-- Mobx
	s(
		{ trig = "mm", descr = "User = types.model('User',  {})" },
		fmt(
			[[
const {} = types.model("{}", {{{}}});
  ]],
			{
				i(1, ""),
				rep(1),
				i(2),
			}
		)
	),
}
