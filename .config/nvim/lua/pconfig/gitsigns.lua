return {
	-- "dnaaun/jjsigns.nvim",
	dir = vim.fn.expand("~/git/jjsigns.nvim"),
	name = "jjsigns.nvim",
	event = "VeryLazy",
	cmd = "Jjsigns",
	module = "jjsigns",
	config = function()
		vim.keymap.set("n", "]h", function()
			require("jjsigns").next_hunk()
		end, { desc = "next hunk" })
		vim.keymap.set("n", "[h", function()
			require("jjsigns").prev_hunk()
		end, { desc = "previous hunk" })
		vim.keymap.set("n", "<leader>gw", function()
			require("jjsigns").stage_hunk()
			require("diffview").emit("refresh_files")
		end, { desc = "stage hunk" })
		vim.keymap.set("n", "<leader>gu", function()
			require("jjsigns").undo_stage_hunk()
			require("diffview").emit("refresh_files")
		end, { desc = "undo stage hunk" })
		vim.keymap.set("n", "<leader>gr", function()
			require("jjsigns").reset_hunk()
		end, { desc = "reset hunk" })
		vim.keymap.set("n", "<leader>gp", function()
			require("jjsigns").preview_hunk()
		end, { desc = "preview hunk" })
		vim.keymap.set("n", "<leader>gb", function()
			require("jjsigns").blame_line()
		end, { desc = "blame line" })
		vim.keymap.set("n", "<leader>gW", function()
			require("jjsigns").stage_buffer()
		end, { desc = "stage buffer" })

		vim.keymap.set("v", "<leader>gw", function()
			require("jjsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "stage_hunk" })
		vim.keymap.set("v", "<leader>gu", function()
			require("jjsigns").undo_stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "undo stage hunk" })
		vim.keymap.set("v", "<leader>gr", function()
			require("jjsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "reset_hunk" })
		require("jjsigns").setup({
			diff_opts = {
				ignore_blank_lines = true,
				ignore_whitespace = true,
				ignore_whitespace_change = true,
				ignore_whitespace_change_at_eol = true,
			},
			current_line_blame_opts = {
				ignore_whitespace = true,
			},
		})
	end,
}
