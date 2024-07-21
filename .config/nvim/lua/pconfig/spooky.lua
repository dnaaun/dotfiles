return {
	"ggandor/spooky.nvim",
	dependencies = { "ggandor/leap.nvim" },
	config = function()
		-- `setup` will create remote text objects from all native ones, by
		-- inserting `r` into the middle (e.g. `ip` -> `irp`), using Leap as the
		-- targeting engine (searching in all windows).
		require("spooky").setup()

		-- Set "boomerang" behavior and automatic paste after yanking:
		vim.api.nvim_create_augroup("SpookyUser", {})
		vim.api.nvim_create_autocmd("User", {
			pattern = "SpookyOperationDone",
			group = "SpookyUser",
			callback = function(event)
				local op = vim.v.operator
				-- Restore cursor position (except after change operation).
				if op ~= "c" then
					event.data.restore_cursor()
				end
				-- (Auto)paste after yanking and restoring the cursor, if the
				-- unnamed register was used.
				if op == "y" and event.data.register == '"' then
					vim.cmd("normal! p")
				end
			end,
		})
	end,
}
