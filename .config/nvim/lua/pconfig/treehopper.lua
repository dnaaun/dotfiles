return {
	"mfussenegger/nvim-treehopper",
	config = function()
		vim.keymap.set("o", "m", require("tsht").nodes, { silent = true })
		vim.keymap.set("v", "m", require("tsht").nodes, { silent = true })
	end,
}
