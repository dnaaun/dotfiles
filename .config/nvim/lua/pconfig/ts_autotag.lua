return {
	"windwp/nvim-ts-autotag",

	ft = { "html", "javascript", "javascriptreact", "typescriptreact", "svelte", "vue","markdown" },
	event = { "InsertEnter" },

	-- I found out about this because I got errors without treeistter.
	dependencies = "nvim-treesitter/nvim-treesitter",

	config = function()
		require("nvim-ts-autotag").setup()
	end,
}
