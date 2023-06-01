return {
	"nvim-telescope/telescope-file-browser.nvim",
  keys = require("pconfig.telescope").keys,
  dependencies = { "nvim-telescope/telescope.nvim" },
	config = function()
		require("telescope").load_extension("file_browser")
	end,
}
