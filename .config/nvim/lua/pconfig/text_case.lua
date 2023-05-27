return {
	"johmsalas/text-case.nvim",
  keys = { "<leader>c" },
	config = function()
		require("textcase").setup({
			prefix = "<leader>c",
		})
		local wk = require("which-key")
		wk.register({
			["<leader>c"] = {
				s = {
					function()
						require("textcase").current_word("to_snake_case")
					end,
					"convert_to_snake_case (manual mapping)",
				},
				S = {
					function()
						require("textcase").lsp_rename("to_snake_case")
					end,
					"LSP convert_to_snake_case (manual mapping)",
				},
			},
		})
	end,
}
