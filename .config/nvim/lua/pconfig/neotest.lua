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
		wk.register({
			["t"] = {
				name = "neotest",
				t = { run.run, "nearest test" },
				f = { run.file, "test file" },
				a = { run.attach, "attach to nearest test" },
				o = { neotest.output.open, "open test output" },
				l = { run.run_last, "run last test" },

				-- idea is to go similar to up and down
				j = { jump.next({ status = "failed" }), "jump to next failed" },
				k = { jump.prev({ status = "failed" }), "jump to prev failed" },
			},
		})
	end,
}
