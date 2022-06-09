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

return {
	-- Escaping braces makings things look crazy here.
	s(
		"c",
		fmt(
			[[
{}interface {}Props {{
  {}
}}

{}function {}({{{}}}: {}Props) {{
  return <div>{}</div>
}}
]],
			{
				i(1, "export "),
				-- dl(2, function()
				-- 	return sn(nil, { i(1, "Component") })
				-- end, { 1 }),
				d(2, function(_, snip)
					-- the returned snippetNode doesn't need a position; it's inserted
					-- "inside" the dynamicNode.
					return sn(nil, {
						-- jump-indices are local to each snippetNode, so restart at 1.
						i(1, vim.fn.substitute(snip.env.TM_FILENAME, "\\..*$", "", "g")),
					})
				end, { 1 }),
				i(3, "// props"),
				rep(1),
				rep(2),
				f(function(_, snip, _)
					local pos_begin = snip.nodes[6].mark:pos_begin()
					local pos_end = snip.nodes[6].mark:pos_end()

					local parser = vim.treesitter.get_parser(0, "tsx")
					local tstree = parser:parse()

					local node = tstree[1]
						:root()
						:named_descendant_for_range(pos_begin[1], pos_begin[2], pos_end[1], pos_end[2])

					while node ~= nil and node:type() ~= "interface_declaration" do
						node = node:parent()
					end

					if node == nil then
						return ""
					end

					-- -- `node` is now surely of type "interface_declaration"
					local prop_names = get_prop_names(node)

					-- Does this lua->vimscript->lua thing cause a slow down? Dunno.
					return vim.fn.join(prop_names, ", ")
				end, { 3 }),
				rep(2),
				i(4, ""),
			}
		)
	),

	s(
		{ trig = "storybook", dscr = "storybook " },
		fmt(
			[[
import {{ Story, Meta }} from "@storybook/react";
import {}, {{
	{}Props,
}} from "./{}";

const Spec: Meta<typeof {}> = {{
	title: "{}/{}",
	component: {},
}};

export default Spec;

const Template: Story<{}Props> = (args) => {{
	return <{} {{...args}} />;
}};

export const Default: Story<{}Props> = Template.bind({{}});
Default.args = {{
  {}
}};
]],
			{
				-- TODO: Refactor to use plenary.
				d(1, function(_, snip)
					local basename = vim.fn.substitute(snip.env.TM_FILENAME, ".*/", "", "")
					basename = vim.fn.substitute(basename, "\\..*$", "", "")
					P(basename)
					return sn(nil, {
						i(1, basename),
					})
				end),
				rep(1),
				rep(1),
				rep(1),
				f(function(_, _snip)
					return "Elements"
					-- P(snip.env.TM_FILENAME)
					-- local abs = Path:new(snip.env.TM_FILENAME):absolute():expand()
					-- P(abs)
					-- local parts = vim.fn.split(abs, "/")
					-- P(parts)
					-- local dirname = parts[#parts - 1]
					-- if dirname == nil then return "" end
					-- return require('std2').str.first_to_upper(dirname)
				end, { 1 }),
				rep(1),
				rep(1),
				rep(1),
				rep(1),
				rep(1),
				i(2, "// props"),
			}
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
const {} = useEffect(() => {}, [])
  ]],
			{ i(1, ""), i(2, "") }
		)
	),
}
