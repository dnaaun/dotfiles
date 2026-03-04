return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
	},
	keys = {
		"tt",
		"tf",
		"ta",
		"to",
		"tl",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-rust"),
				require("neotest-rspec")({}),
				require("neotest-jest")({}),
			},
			icons = {
				child_indent = "│",
				child_prefix = "├",
				collapsed = "─",
				expanded = "╮",
				failed = "✖",
				final_child_indent = " ",
				final_child_prefix = "╰",
				non_collapsible = "─",
				passed = "✔",
				running = "↻",
				skipped = "ﰸ",
				unknown = "?",
			},

			floating = {
				max_width = 0.99,
			},

			strategies = {
				integrated = {
					height = 100,
					width = 400,
				},
			},
		})

		local neotest = require("neotest")
		local run = neotest.run
		local jump = neotest.jump
		vim.keymap.set("n", "tt", run.run, { desc = "nearest test" })
		vim.keymap.set("n", "tf", run.file, { desc = "test file" })
		vim.keymap.set("n", "ta", run.attach, { desc = "attach to nearest test" })
		vim.keymap.set("n", "to", neotest.output.open, { desc = "open test output" })
		vim.keymap.set("n", "tl", run.run_last, { desc = "run last test" })
		vim.keymap.set("n", "tj", jump.next({ status = "failed" }), { desc = "jump to next failed" })
		vim.keymap.set("n", "tk", jump.prev({ status = "failed" }), { desc = "jump to prev failed" })
	end,
}
