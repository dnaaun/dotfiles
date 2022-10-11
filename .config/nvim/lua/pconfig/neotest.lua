return {
	"nvim-neotest/neotest",
	requires = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
		"olimorris/neotest-rspec",
	},
	ft = { "ruby", "typescript", "tsx", "ruby", "rust" },

	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-rust"),
				require("neotest-rspec"),
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
		local wk = require("which-key")
		wk.register({
			["t"] = {
				name = "neotest",
				t = { run.run, "nearest test" },
				f = { run.file, "test file" },
				a = { run.attach, "attach to nearest test" },
				o = { neotest.output.open, "open test output" },
				l = { run.run_last, "run last test" },
			},
		})
	end,
}
