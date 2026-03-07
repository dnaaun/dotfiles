return {
	"nvim-telescope/telescope-file-browser.nvim",
  lazy = true,
  dependencies = { "nvim-telescope/telescope.nvim" },
	config = function()
		require("telescope").load_extension("file_browser")
	end,
}
