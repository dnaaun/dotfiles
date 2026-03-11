return {
  "kylechui/nvim-surround",
  event = "BufRead",
	config = function()
		require("nvim-surround").setup({
      mappings_style = "surround",
    })
	end,
}
