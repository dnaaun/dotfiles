return {
	"rcarriga/vim-ultest",
	requires = { "vim-test/vim-test" },
	run = ":UpdateRemotePlugins",
	ft = { "ruby" },
	setup = function()
		vim.g.ultest_running_sign = "🟡"
		-- vim.g.ultest_icons = 0
		-- (From README) easy way to trick unittest/rspec/testing frameworks into outputting color.
		vim.g.ultest_use_pty = 1
	end,
	config = function()
		-- The default icons there.

		-- Aint spending another minute this week editing my .dotfiles, including
		-- standardizing the two ways of mapping things below.
		vim.api.nvim_set_keymap("n", "<leader>tsn", "<Plug>(ultest-stop-nearest)", {})
		vim.api.nvim_set_keymap("n", "<leader>tsf", "<Plug>(ultest-stop-file)", {})
		vim.api.nvim_set_keymap("n", "<leader>ta", "<Plug>(ultest-attach)", {})
		vim.api.nvim_set_keymap("n", "<leader>to", "<Plug>(ultest-output-jump)", {})
		vim.api.nvim_set_keymap("n", "]t", "<Plug>(ultest-next-fail)", {})
		vim.api.nvim_set_keymap("n", "[t", "<Plug>(ultest-prev-fail)", {})
		vim.api.nvim_set_keymap("n", "<leader>tf", "<Plug>(ultest-run-file)", {})
		vim.api.nvim_set_keymap("n", "<leader>tn", "<Plug>(ultest-run-nearest)", {})
		vim.api.nvim_set_keymap("n", "<leader>tl", "<Plug>(ultest-run-last)", {})

		--- Integrate vim-ultest with nvim-dap
		-- https://github.com/rcarriga/vim-ultest/blob/0aa467db97a075c576e97424865a57a457fd4851/doc/ultest.txt#L345-L379
		local rspec_dap_builder = function(cmd)
			local programArgs = vim.list_slice(cmd, 2) -- Python version is cmd[1:]
			local configuration = {
				dap = {
					type = "ruby",
					request = "launch",
					name = "Debugged Rspec",
					program = "bundle",
					programArgs = programArgs,
					useBundler = false,
				},
			}
			return configuration
		end

		require("ultest").setup({
			builders = {
				["ruby#rspec"] = rspec_dap_builder,
			},
		})
	end,
}
