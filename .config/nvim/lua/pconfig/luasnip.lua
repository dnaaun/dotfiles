return {
	"L3MON4D3/LuaSnip",
	config = function()
		local ls = require("luasnip")

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

		--- Used for useState() so far
		--- @param str string
		local function first_to_upper(str)
			return (str:gsub("^%l", string.upper))
		end

		local rep2 = function(idx)
			return f(function(arg)
				P(arg)
				return arg[1][1]
			end, { idx })
		end

    local ts_utils = require("nvim-treesitter.ts_utils");

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
          local prop_name = ts_utils.get_node_text(prop_iden, 0)[1]
					prop_names[#prop_names + 1] = prop_name
				end
			end

			return prop_names
		end

		ls.add_snippets("typescriptreact", {
			s(
				"us",
				fmt("const [{}, {}] = useState({{{}}})", {
					i(1, "name"),
					f(function(arg)
						local state_name = arg[1][1]
						return "set" .. first_to_upper(state_name)
					end, { 1 }),
					i(2),
				})
			),

			-- Escaping braces makings things look crazy here.
			s(
				"c",
				fmt(
					[[
{}interface {}Props {{
  {}
}}

{}function {}({{{}}}: {}Props) {{
  {}
}}
]],
					{
						i(1, "export "),
						i(2, "Component"),
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
						i(5, "return <div></div>"),
					}
				)
			),
		})

		ls.add_snippets("all", {
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
		})

		-- Load my snipmate style snippets
		require("luasnip.loaders.from_snipmate").load()
	end,
}
