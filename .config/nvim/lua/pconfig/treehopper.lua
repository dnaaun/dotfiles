return {
	"mfussenegger/nvim-treehopper",
	-- branch = "add-config-to-specify-parser-for-filetypes",
	-- keys = { { "m", mode = "v" }, { "m", mode = "o" } },
	config = function()
		local wk = require("which-key")

		wk.add({
			{ "m", require("tsht").nodes, desc = "Treehopper Nodes", mode = "o" },
			{ "m", require("tsht").nodes, desc = "Treehopper Nodes", mode = "x" },
		})
	end,
}
