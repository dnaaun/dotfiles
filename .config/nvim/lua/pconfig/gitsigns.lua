return {
	"lewis6991/gitsigns.nvim",
	requires = { "nvim-lua/plenary.nvim" },
	event = "VeryLazy",
	module = "gitsigns",
	config = function()
		vim.keymap.set("n", "]h", function() require("gitsigns").next_hunk() end, { desc = "next hunk" })
		vim.keymap.set("n", "[h", function() require("gitsigns").prev_hunk() end, { desc = "previous hunk" })
		vim.keymap.set("n", "<leader>gw", function()
			require("gitsigns").stage_hunk()
			require("diffview").emit("refresh_files")
		end, { desc = "stage hunk" })
		vim.keymap.set("n", "<leader>gu", function()
			require("gitsigns").undo_stage_hunk()
			require("diffview").emit("refresh_files")
		end, { desc = "undo stage hunk" })
		vim.keymap.set("n", "<leader>gr", function() require("gitsigns").reset_hunk() end, { desc = "reset hunk" })
		vim.keymap.set("n", "<leader>gp", function() require("gitsigns").preview_hunk() end, { desc = "preview hunk" })
		vim.keymap.set("n", "<leader>gb", function() require("gitsigns").blame_line() end, { desc = "blame line" })
		vim.keymap.set("n", "<leader>gW", function() require("gitsigns").stage_buffer() end, { desc = "stage buffer" })

		vim.keymap.set("v", "<leader>gw", function()
			require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "stage_hunk" })
		vim.keymap.set("v", "<leader>gu", function()
			require("gitsigns").undo_stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "undo stage hunk" })
		vim.keymap.set("v", "<leader>gr", function()
			require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "reset_hunk" })
		require("gitsigns").setup({
			diff_opts = {
				ignore_whitespace = true,
			},
		})
	end,
}
