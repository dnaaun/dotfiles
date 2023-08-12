return {
	"luckasRanarison/nvim-devdocs",
	cmd = {
		"DevdocsOpen",
		"DevdocsFetch",
		"DevdocsInstall",
		"DevdocsUninstall",
		"DevdocsOpenFloat",
		"DevdocsUpdate",
		"DevdocsUpdateAll",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {},
}
