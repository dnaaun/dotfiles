return {
  "nvim-telescope/telescope-fzf-native.nvim",
  keys = require("pconfig.telescope").keys,
  event = require("pconfig.telescope").event,
  module = require("pconfig.telescope").module,
	build = "make",
	config = function()
		require("telescope").load_extension("fzf")
	end,
}
