return {
	"nvim-telescope/telescope-file-browser.nvim",
  keys = require("pconfig.telescope").keys,
	config = function()
		require("telescope").load_extension("file_browser")
	end,
}
