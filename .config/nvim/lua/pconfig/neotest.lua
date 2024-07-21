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
		local wk = require("which-key")
		wk.add({
			{ "tt", run.run, desc = "nearest test", group = "neotest" },
			{ "tf", run.file, desc = "test file", group = "neotest" },
			{ "ta", run.attach, desc = "attach to nearest test", group = "neotest" },
			{ "to", neotest.output.open, desc = "open test output", group = "neotest" },
			{ "tl", run.run_last, desc = "run last test", group = "neotest" },
			{ "tj", jump.next({ status = "failed" }), desc = "jump to next failed", group = "neotest" },
			{ "tk", jump.prev({ status = "failed" }), desc = "jump to prev failed", group = "neotest" },
		})
	end,
}
