vim.keymap.set("o", "m", function() require("tsht").nodes() end, { desc = "Treehopper Nodes" })
vim.keymap.set("x", "m", function() require("tsht").nodes() end, { desc = "Treehopper Nodes" })

return {
	"mfussenegger/nvim-treehopper",
	lazy = true,
}
