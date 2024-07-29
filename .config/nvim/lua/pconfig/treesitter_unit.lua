return {
	"David-Kunz/treesitter-unit",
	config = function()
		-- Visual mode mappings
		vim.keymap.set("x", "iu", require("treesitter-unit").select, { noremap = true })
		vim.keymap.set("x", "au", function()
			require("treesitter-unit").select(true)
		end, { noremap = true })

		-- Operator-pending mode mappings
		vim.keymap.set("o", "iu", require("treesitter-unit").select, { noremap = true, silent = true })
		vim.keymap.set("o", "au", function()
			require("treesitter-unit").select(true)
		end, { noremap = true, silent = true })
	end,
}
