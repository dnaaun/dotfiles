-- Which key doesn't play nice with floating windows, which breaks harpoon.
-- https://github.com/folke/which-key.nvim/issues/300
-- https://github.com/ThePrimeagen/harpoon/issues/195
-- This makes it so that in harpoon buffers, which-key will only show up 10 seconds
-- after being in operator pending mode.
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = vim.api.nvim_create_augroup("IncreaseTimeoutLenForHarpoon", {}),
	callback = function()
		if vim.opt.filetype == "harpoon" then
			vim.opt_local.timeoutlen = 10000
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufLeave" }, {
	group = vim.api.nvim_create_augroup("ResetTimeoutlenAfterHarpoon", {}),
	callback = function()
		if vim.opt.filetype == "harpoon" then
			vim.opt_local.timeoutlen = 0
		end
	end,
})

return {
	"ThePrimeagen/harpoon",
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- We want to use telescope's harpoon extension.
		"nvim-telescope/telescope.nvim",
	},
	-- keys = {
	--   "m1",
	--   "m2",
	--   "m3",
	--   "m4",
	--   "m5",
	--   "m6",
	--   "m7",
	--   "m8",
	--   "m9",
	--   "m0",
	--   "ma",
	--   "ms",
	--   "md",
	--   "mx",
	--   "mm",
	-- },

	config = function()
		local wk = require("which-key")
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		require("telescope").load_extension("harpoon")

		-- direction will be added to the numeric mappings' labels.
		local make_wk_mappings = function(direction, prefix)
			if direction ~= "horizontal" and direction ~= "vertical" then
				direction = ""
			end

			local wk_mappings = {}

			for i = 1, 9 do
				wk_mappings[i] = {
					prefix .. tostring(i),
					function()
						if direction == "vertical" then
							vim.cmd("vsplit")
						elseif direction == "horizontal" then
							vim.cmd("split")
						end
						ui.nav_file(i)
					end,
					desc = direction .. " nav to file" .. i,

					group = "harpoon " .. direction,
				}
			end

			return wk_mappings
		end
		wk.add(make_wk_mappings("", "m"))
		wk.add({
			{ "ma", mark.add_file, desc = "add file" },
			{ "md", mark.rm_file, desc = "remove file" },
			-- I chose m because <leader>m is my harpoon prefix
			-- and this is probably going to be a frequent operation.
			{ "mm", ui.toggle_quick_menu, desc = "harpoon" },
		})
    wk.add(make_wk_mappings("horizontal", "mx"))
    wk.add(make_wk_mappings("vertical", "ms"))

		require("harpoon").setup({
			menu = {
				width = vim.api.nvim_win_get_width(0) - 4,
			},
		})
	end,
}
