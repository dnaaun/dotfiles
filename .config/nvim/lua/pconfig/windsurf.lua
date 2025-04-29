return {
	"Exafunction/windsurf.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	config = function()
		require("codeium").setup({
			virtual_text = {

        -- Breaks escape
				enabled = false,
				key_bindings = {
					-- Accept the current completion.
					accept = "<Tab>",
					-- Accept the next word.
					accept_word = false,
					-- Accept the next line.
					accept_line = false,
					-- Clear the virtual text.
					clear = false,
					-- Cycle to the next completion.
					next = "<C-]>",
					-- Cycle to the previous completion.
					prev = "<C-[>",
				},
			},
		})
	end,
}
