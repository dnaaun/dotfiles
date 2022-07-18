return {
	"ziontee113/syntax-tree-surfer",
	config = function()
    opts = {}
		local sts = require("syntax-tree-surfer")
		--vim.keymap.set("n", "gfu", function() -- only jump to functions
		--	sts.targeted_jump({ "function", "function_definition" })
		--	--> In this example, the Lua language schema uses "function",
		--	--  when the Python language uses "function_definition"
		--	--  we include both, so this keymap will work on both languages
		--end, opts)

		vim.keymap.set("n", "gj", function() -- jump to all that you specify
			sts.targeted_jump({
				"if_statement",
				"else_clause",
				"else_statement",
				"elseif_statement",
				"for_statement",
				"while_statement",
				"switch_statement",
			})
		end, opts)
	end,
}
