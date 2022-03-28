return {
	"stevearc/aerial.nvim",
	after = { "nvim-lspconfig" },
	config = function()
		local aerial = require("aerial")
    require('telescope').load_extension('aerial')

		local custom_attach = function(client)
			aerial.on_attach(client)
			-- Toggle the aerial window with <leader>a
			vim.api.nvim_buf_set_keymap(0, "n", "<leader>a", "<cmd>AerialToggle!<CR>", {})
			-- Jump forwards/backwards with '{' and '}'
			vim.api.nvim_buf_set_keymap(0, "n", "{", "<cmd>AerialPrev<CR>", {})
			vim.api.nvim_buf_set_keymap(0, "n", "}", "<cmd>AerialNext<CR>", {})
			-- Jump up the tree with '[[' or ']]'
			vim.api.nvim_buf_set_keymap(0, "n", "[[", "<cmd>AerialPrevUp<CR>", {})
			vim.api.nvim_buf_set_keymap(0, "n", "]]", "<cmd>AerialNextUp<CR>", {})
			vim.api.nvim_set_keymap("n", "<leader>ls", "<cmd>Telescope aerial<CR>", { noremap = true })
		end

		table.insert(_G.lsp_config_on_attach_callbacks, custom_attach)
	end,
}
