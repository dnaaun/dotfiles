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
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- We want to use telescope's harpoon extension.
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		-- direction will be added to the numeric mappings' labels.
		local make_mappings = function(direction, prefix)
			if direction ~= "horizontal" and direction ~= "vertical" then
				direction = ""
			end

			local wk_mappings = {}

			for i = 1, 9 do
				local lhs = prefix .. tostring(i)
				vim.keymap.set("n", lhs, function()
					if direction == "vertical" then
						vim.cmd("vsplit")
					elseif direction == "horizontal" then
						vim.cmd("split")
					end
					local harpoon = require("harpoon")
					harpoon:list():select(i)
				end, { desc = direction .. " nav to file" .. i })
			end
		end

		harpoon:extend({
			UI_CREATE = function(cx)
				vim.keymap.set("n", "<C-v>", function()
					harpoon.ui:select_menu_item({ vsplit = true })
				end, { buffer = cx.bufnr })

				vim.keymap.set("n", "<C-x>", function()
					harpoon.ui:select_menu_item({ split = true })
				end, { buffer = cx.bufnr })

				vim.keymap.set("n", "<C-t>", function()
					harpoon.ui:select_menu_item({ tabedit = true })
				end, { buffer = cx.bufnr })

				for i = 1, 9 do
					vim.keymap.set("n", tostring(i), function()
						local harpoon = require("harpoon")
						harpoon:list():select(i)
					end, { buffer = cx.bufnr })
				end
			end,
		})

		vim.keymap.set("n", "m", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "harpoon quickmenu" })

		vim.keymap.set("n", "<leader>m", function()
			local harpoon = require("harpoon")
			harpoon:list():add()
		end, { desc = "add cur file to harpoon" })
	end,
}
