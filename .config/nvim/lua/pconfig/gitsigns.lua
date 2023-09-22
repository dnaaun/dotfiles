return {
	"lewis6991/gitsigns.nvim",
	requires = { "nvim-lua/plenary.nvim" },
	event = "VeryLazy",
	module = "gitsigns",
	config = function()
		require("which-key").register({
			["]h"] = {
				function()
					require("gitsigns").next_hunk()
				end,
				"next hunk",
			},
			["[h"] = {
				function()
					require("gitsigns").prev_hunk()
				end,
				"previous hunk",
			},
			["<leader>g"] = {
				w = {
					function()
						require("gitsigns").stage_hunk()
					end,
					"stage hunk",
				},
				u = {
					function()
						require("gitsigns").undo_stage_hunk()
					end,
					"undo stage hunk",
				},
				r = {
					function()
						require("gitsigns").reset_hunk()
					end,
					"reset hunk",
				},
				p = {
					function()
						require("gitsigns").preview_hunk()
					end,
					"preview hunk",
				},
				b = {
					function()
						require("gitsigns").blame_line()
					end,
					"blame line",
				},
				W = {
					function()
						require("gitsigns").stage_buffer()
					end,
					"stage buffer",
				},
			},
		}, { mode = "n" })

		require("which-key").register({
			["<leader>g"] = {
				w = {
					function()
						require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end,
					"stage_hunk",
				},
				u = {
					function()
						require("gitsigns").undo_stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end,
					"stage hunk",
				},
				r = {
					function()
						require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end,
					"reset_hunk",
				},
			},
		}, { mode = "v" })
		require("gitsigns").setup({})
	end,
}
