return {
	"lewis6991/gitsigns.nvim",
	requires = { "nvim-lua/plenary.nvim" },
	event = "VeryLazy",
	module = "gitsigns",
	config = function()
		require("which-key").add({
			{
				"]h",
				function()
					require("gitsigns").next_hunk()
				end,
				desc = "next hunk",
				mode = "n",
			},
			{
				"[h",
				function()
					require("gitsigns").prev_hunk()
				end,
				desc = "previous hunk",
				mode = "n",
			},
			{
				"<leader>gw",
				function()
					require("gitsigns").stage_hunk()
					require("diffview").emit("refresh_files")
				end,
				desc = "stage hunk",
				mode = "n",
			},
			{
				"<leader>gu",
				function()
					require("gitsigns").undo_stage_hunk()
					require("diffview").emit("refresh_files")
				end,
				desc = "undo stage hunk",
				mode = "n",
			},
			{
				"<leader>gr",
				function()
					require("gitsigns").reset_hunk()
				end,
				desc = "reset hunk",
				mode = "n",
			},
			{
				"<leader>gp",
				function()
					require("gitsigns").preview_hunk()
				end,
				desc = "preview hunk",
				mode = "n",
			},
			{
				"<leader>gb",
				function()
					require("gitsigns").blame_line()
				end,
				desc = "blame line",
				mode = "n",
			},
			{
				"<leader>gW",
				function()
					require("gitsigns").stage_buffer()
				end,
				desc = "stage buffer",
				mode = "n",
			},
		})

		require("which-key").add({
			{
				"<leader>gw",
				function()
					require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end,
				desc = "stage_hunk",
				mode = "v",
			},
			{
				"<leader>gu",
				function()
					require("gitsigns").undo_stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end,
				desc = "undo stage hunk",
				mode = "v",
			},
			{
				"<leader>gr",
				function()
					require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end,
				desc = "reset_hunk",
				mode = "v",
			},
		})
		require("gitsigns").setup({
			diff_opts = {
				-- ignore_whitespace = true,
			},
		})
	end,
}
