local mapfunc = require("std2").mapfunc

-- I wish vim-ultest had this:
-- TODO: Make this work.
local attach_or_open_output = function()
	local nearest_test = vim.fn._ultest_get_nearest_test(vim.fn.line("."), vim.fn.expand("%:."), false)
  --print("Found", vim.inspect(nearest_test))
  if not nearest_test then return end
	if nearest_test.running then
    --print("is running")
		vim.fn["ultest#output#attach"](nearest_test)
	else
    --print("is not running")
		vim.fn["ultest#output#open"](nearest_test)
	end
end

mapfunc("n", "to", attach_or_open_output, {}, "ultest attach or open output")
return {
	"rcarriga/vim-ultest",
	requires = { "vim-test/vim-test" },
	run = ":UpdateRemotePlugins",
	ft = { "ruby", "typescript",  "typescriptreact" },
	setup = function()
		vim.g.ultest_running_sign = "🟡"
		-- vim.g.ultest_icons = 0
		-- (From README) easy way to trick unittest/rspec/testing frameworks into outputting color.
		vim.g.ultest_use_pty = 1
	end,
	config = function()
		-- The default icons there.

		vim.api.nvim_set_keymap("n", "tsn", "<Plug>(ultest-stop-nearest)", {})
		vim.api.nvim_set_keymap("n", "tsf", "<Plug>(ultest-stop-file)", {})
		vim.api.nvim_set_keymap("n", "ta", "<Plug>(ultest-attach)", {})
		vim.api.nvim_set_keymap("n", "ta", "<Plug>(ultest-attach)", {})
		vim.api.nvim_set_keymap("n", "to", "<Plug>(ultest-output-jump)", {})
		vim.api.nvim_set_keymap("n", "]t", "<Plug>(ultest-next-fail)", {})
		vim.api.nvim_set_keymap("n", "[t", "<Plug>(ultest-prev-fail)", {})
		vim.api.nvim_set_keymap("n", "tf", "<Plug>(ultest-run-file)", {})
		vim.api.nvim_set_keymap("n", "tn", "<Plug>(ultest-run-nearest)", {})
		vim.api.nvim_set_keymap("n", "tl", "<Plug>(ultest-run-last)", {})

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
