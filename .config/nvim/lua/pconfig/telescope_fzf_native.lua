return {
	"nvim-telescope/telescope-fzf-native.nvim",
  keys = require("pconfig.telescope").keys,
	build = "make",
	config = function()
		require("telescope").load_extension("fzf")
	end,
}
