return {
	"folke/twilight.nvim",
  keys = { "<leader>vt" },
	config = function()
		require("twilight").setup({
			dimming = {
				alpha = 0.15, -- amount of dimming
				-- we try to get the foreground from the highlight groups or fallback color
				color = { "Normal", "#ffffff" },
				inactive = true, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
			},
			context = 10, -- amount of lines we will try to show around the current line
			treesitter = true, -- use treesitter when available for the filetype
			-- treesitter is used to automatically expand the visible text,
			expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
				-- typescript related
				"lexical_declaration",
				"function_declaration",

				"function",
				"method",

				-- lua
				"function_definition",

				"table",
				"if_statement",
			},
		})

		local g = vim.api.nvim_create_augroup("twilight", {})
		-- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = require("twilight").enable, group = g })
		vim.keymap.set("n", "<leader>vt", ":Twilight<CR>", {})
	end,
}
