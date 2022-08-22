return {
	"nvim-neotest/neotest",
	requires = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
		"olimorris/neotest-rspec",
	},
	ft = { "ruby", "typescript", "tsx" },

	config = function()
		require("neotest").setup({
			adapters = {
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
          unknown = "?"
        }
		})

    local neotest = require("neotest")
		local run = neotest.run
		local wk = require("which-key")
		wk.register({
			["t"] = {
        name = "neotest",
				t = { run.run, "nearest test" },
				f = { run.file, "test file" },
        a = { run.attach, "attach to nearest test"},
        o = { neotest.output.open, "open test output" },
        l = { run.run_last, "run last test" }
			},
		})
	end,
}
