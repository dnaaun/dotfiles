return {
	"lukas-reineke/indent-blankline.nvim",
  event = { "InsertEnter" },
	config = function()
		require("indent_blankline").setup({
			space_char_blankline = " ",
			show_end_of_line = false,
		})
		vim.g.indent_blankline_buftype_exclude = { "terminal" }
	end,
}
