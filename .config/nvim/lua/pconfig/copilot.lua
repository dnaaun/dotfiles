return {
	"zbirenbaum/copilot.lua",
  event = "InsertEnter",
	config = function()
		require("copilot").setup({
			-- "It is recommended to disable copilot.lua's suggestion and panel
			-- modules, as they can interfere with completions properly appearing in
			-- copilot-cmp."
			--   - https://github.com/zbirenbaum/copilot-cmp#install
			suggestion = { enabled = true, auto_trigger = true },
			panel = { enabled = true },

			filetypes = {
				tex = false,
			},
		})

		-- Map in insert mode <C-c> to call copilot.suggestion:
		vim.keymap.set("i", "<C-c>", require("copilot.suggestion").next, { noremap = true, silent = true })
		vim.keymap.set("i", "<C-e>", require("copilot.suggestion").accept, { noremap = true, silent = true })
	end,
}
