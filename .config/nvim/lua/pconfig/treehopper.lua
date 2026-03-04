return {
	"mfussenegger/nvim-treehopper",
	-- branch = "add-config-to-specify-parser-for-filetypes",
	-- keys = { { "m", mode = "v" }, { "m", mode = "o" } },
	config = function()
		vim.keymap.set("o", "m", require("tsht").nodes, { desc = "Treehopper Nodes" })
		vim.keymap.set("x", "m", require("tsht").nodes, { desc = "Treehopper Nodes" })
	end,
}
