return {
	"davidatsurge/nvim-treehopper",
  branch = "add-config-to-specify-parser-for-filetypes",
	config = function()
		vim.keymap.set("o", "m", require("tsht").nodes, { silent = true })
		vim.keymap.set("v", "m", require("tsht").nodes, { silent = true })
    require("tsht").config.ft_to_parser.typescriptreact = "tsx"
	end,
}