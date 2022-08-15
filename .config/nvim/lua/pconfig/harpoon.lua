-- Which key doesn't play nice with floating windows, which breaks harpoon.
-- https://github.com/folke/which-key.nvim/issues/300
-- https://github.com/ThePrimeagen/harpoon/issues/195
-- This makes it so that in harpoon buffers, which-key will only show up 10 seconds
-- after being in operator pending mode.
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "harpoon" },
	group = vim.api.nvim_create_augroup("WhichKeyBeNiceToHarpoon", {}),
	callback = function()
		vim.opt_local.timeoutlen = 10000
	end,
})

return {
	"ThePrimeagen/harpoon",
	requires = "nvim-lua/plenary.nvim",
	config = function()
		local wk = require("which-key")
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		local wk_mappings = {
			name = "Harpoon!",
			a = { mark.add_file, "add file" },
			x = { mark.rm_file, "remove file" },

			-- I chose m because <leader>m is my harpoon prefix
			-- and this is probably going to be a frequent operation.
			m = { ui.toggle_quick_menu, "toggle quick menu" },
		}

		for i = 2, 9 do
			wk_mappings[tostring(i)] = {
				function()
					ui.nav_file(i)
				end,
				"nav to file " .. i,
			}
		end

		wk.register({
			-- I chose m because it's close to my <leader>: ","
			["<leader>m"] = wk_mappings,
		})

		require("harpoon").setup({
			menu = {
				width = vim.api.nvim_win_get_width(0) - 4,
			},
		})
	end,
}
